# -*- mode: yaml  -*-
# vim: syntax=yaml:sw=2

{% from "postgres/map.jinja" import postgres with context %}

{% if postgres.use_upstream_repo %}
include:
  - postgres.upstream
{% endif %}

postgresql-config-dir:
  file.directory:
    - name: {{ postgres.conf_dir }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - makedirs: True
    - require:
      - pkg: postgresql-installed
      - cmd: postgresql-cluster-prepared

postgresql-installed:
  pkg.installed:
    - name: {{ postgres.pkg }}
    - refresh: {{ postgres.use_upstream_repo }}

# make sure the data directory and contents have been initialized
postgresql-cluster-prepared:
  cmd.run:
    - cwd: /
    - name: {{ postgres.prepare_cluster.command }}
    - user: {{ postgres.prepare_cluster.user }}
    - unless:
      - {{ postgres.prepare_cluster.test }}
    - require:
      - pkg: postgresql-installed
    - env:
{% for name, value in postgres.prepare_cluster.env.items() %}
        {{ name }}: {{ value }}
{% endfor %}

postgresql-running:
  service.running:
    - enable: True
    - reload: True
    - name: {{ postgres.service }}
    - reload: true
    - require:
      - cmd: postgresql-cluster-prepared

{% if postgres.pkgs_extra %}
{% for pkg in postgres.pkgs_extra %}
postgresql-extra-pkgs-installed_{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{% endfor %}
{% endif %}

{% if postgres.postgresconf %}
postgresql-conf:
  file.blockreplace:
    - name: {{ postgres.conf_dir }}/postgresql.conf
    - marker_start: "# Managed by SaltStack: listen_addresses: please do not edit"
    - marker_end: "# Managed by SaltStack: end of salt managed zone --"
    - content: |
        {{ postgres.postgresconf|indent(8) }}
    - show_changes: True
    - append_if_not_found: True
    {% if not postgres.postgresconf_backup|default(True) -%}
    - backup: False
    {% endif -%}
    - watch_in:
       - service: postgresql-running
    - require:
      - file: postgresql-config-dir
{% endif %}

postgresql-pg_hba:
  file.managed:
    - name: {{ postgres.conf_dir }}/pg_hba.conf
    - source: {{ postgres['pg_hba.conf'] }}
    - template: jinja
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - mode: 644
    - require:
      - file: postgresql-config-dir
    - watch_in:
      - service: postgresql-running

{% for name, user in postgres.users.items()  %}
postgresql-user-{{ name }}:
{% if user.get('ensure', 'present') == 'absent' %}
  postgres_user.absent:
    - name: {{ name }}
    - user: {{ user.get('runas', postgres.user) }}
{% if user.get('user') %}
    - db_user: {{ user.user }}
{% endif %}
{% else %}
  postgres_user.present:
    - name: {{ name }}
    - createdb: {{ user.get('createdb', False) }}
    - createroles: {{ user.get('createroles', False) }}
    - createuser: {{ user.get('createuser', False) }}
    - inherit: {{ user.get('inherit', True) }}
    - replication: {{ user.get('replication', False) }}
    - password: {{ user.password }}
    - superuser: {{ user.get('superuser', False) }}
    - user: {{ user.get('runas', postgres.user) }}
{% if user.get('user') %}
    - db_user: {{ user.get('runas', postgres.user) }}
{% endif %}
{% endif %}
    - require:
      - service: postgresql-running
{% if user.get('user') %}
      - postgres_user: postgresql-user-{{ user.user }}
{% endif %}
{% endfor %}

{% for name, tblspace in postgres.tablespaces.items()  %}
postgresql-tablespace-dir-perms-{{ tblspace.directory}}:
  file.directory:
    - name: {{ tblspace.directory }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - makedirs: True
    - recurse:
      - user
      - group

postgresql-tablespace-{{ name }}:
  postgres_tablespace.present:
    - name: {{ name }}
    - directory: {{ tblspace.directory }}
    - user: {{ tblspace.get('runas', postgres.user) }}
{% if tblspace.get('db_user') %}
    - db_user: {{ tblspace.db_user }}
{% endif %}
{% if tblspace.get('db_password') %}
    - db_password: {{ tblspace.db_password }}
{% endif %}
{% if tblspace.get('db_host') %}
    - db_host: {{ tblspace.db_host }}
{% endif %}
{% if tblspace.get('db_port') %}
    - db_port: {{ tblspace.db_port }}
{% endif %}
{% if tblspace.get('owner') %}
    - owner: {{ tblspace.owner }}
{% endif %}
    - require:
      - service: postgresql-running
      - file: postgresql-tablespace-dir-perms-{{ tblspace.directory}}
{% endfor %}

{% for name, db in postgres.databases.items()  %}
postgresql-db-{{ name }}:
{% if db.get('ensure', 'present') == 'absent' %}
  postgres_database.absent:
    - name: {{ name }}
    - user: {{ db.get('runas', postgres.user) }}
{% if db.get('user') %}
    - db_user: {{ db.user }}
{% endif %}
    - require:
      - service: postgresql-running
{% else %}
  postgres_database.present:
    - name: {{ name }}
    {% if 'encoding' in db %}
    - encoding: {{ db.encoding }}
    {% endif %}
    {% if 'lc_ctype' in db %}
    - lc_ctype: {{ db.lc_ctype }}
    {% endif %}
    {% if 'lc_collate' in db %}
    - lc_collate: {{ db.lc_collate }}
    {% endif %}
    - template: {{ db.get('template', 'template0') }}
    - tablespace: {{ db.get('tablespace', 'pg_default') }}
    {% if db.get('owner') %}
    - owner: {{ db.owner }}
    {% endif %}
    - user: {{ db.get('runas', postgres.user) }}
    {% if db.get('db_user') %}
    - db_user: {{ db.db_user }}
    {% endif %}
    {% if db.get('db_password') %}
    - db_password: {{ db.db_password }}
    {% endif %}
    {% if db.get('db_host') %}
    - db_host: {{ db.db_host }}
    {% endif %}
    {% if db.get('db_port') %}
    - db_port: {{ db.db_port }}
    {% endif %}
    - require:
      - service: postgresql-running
    {% if db.get('user') %}
      - postgres_user: postgresql-user-{{ db.user }}
    {% endif %}
    {% if db.get('owner') %}
      - postgres_user: postgresql-user-{{ db.owner }}
    {% endif %}
    {% if db.get('tablespace') %}
      - postgres_tablespace: postgresql-tablespace-{{ db.get('tablespace') }}
    {% endif %}

{# NOTE: postgres_schema doesn't have a 'runas' equiv. at all #}
{% for schema_name, schema in db.get('schemas', dict()).items() %}
postgresql-schema-{{ schema_name }}-for-db-{{ name }}:
{% if schema.get('ensure', 'present') == 'absent' %}
  postgres_schema.absent:
    - name: {{ schema_name }}
    {% if schema.get('user') %}
    - db_user: {{ schema.user }}
    {% endif %}
    - require:
      - service: postgresql-running
{% else %}
  postgres_schema.present:
    - name: {{ schema_name }}
    - dbname: {{ name }}
    {% if schema.get('user') %}
    - db_user: {{ schema.user }}
    {% endif %}
{% if schema.get('owner') %}
    - owner: {{ schema.owner }}
{% endif %}
    - require:
      - service: postgresql-running
      - postgres_database: postgresql-db-{{ name }}
    {% if schema.get('user') %}
      - postgres_user: postgresql-user-{{ schema.user }}
    {% endif %}
    {% if schema.get('owner') %}
      - postgres_user: postgresql-user-{{ schema.owner }}
    {% endif %}
{% endif %}
{% endfor %}

{% for ext_name, ext in db.get('extensions', dict()).items() %}
postgresql-ext-{{ ext_name }}-for-db-{{ name }}:
  {% if ext.get('ensure', 'present') == 'absent' %}
  postgres_extension.absent:
    - name: {{ ext_name }}
    - user: {{ ext.get('runas', postgres.user) }}
    {% if ext.get('user') %}
    - db_user: {{ ext.user }}
    {% endif %}
    - require:
      - service: postgresql-running
  {% else %}
  postgres_extension.present:
    - name: {{ ext_name }}
    - user: {{ ext.get('runas', postgres.user) }}
    {% if ext.get('user') %}
    - db_user: {{ ext.user }}
    {% endif %}
    {% if ext.get('version') %}
    - ext_version: {{ ext.version }}
    {% endif %}
    {% if ext.get('schema') %}
    - schema: {{ ext.schema }}
    {% endif %}
    - maintenance_db: {{ name }}
    - require:
      - service: postgresql-running
      - postgres_database: postgresql-db-{{ name }}
    {% if ext.get('user') %}
      - postgres_user: postgresql-user-{{ ext.user }}
    {% endif %}
    {% if ext.get('schema') %}
      - postgres_schema: postgresql-schema-{{ ext.schema }}-for-db-{{ name }}
    {% endif %}
  {% endif %}
{% endfor %}

{% endif %}
{% endfor %}

