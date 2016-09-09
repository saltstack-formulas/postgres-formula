# -*- mode: yaml -*-

{%- from "postgres/map.jinja" import postgres with context -%}
{%- from "postgres/macros.jinja" import format_state with context -%}

{%- if postgres.use_upstream_repo %}

include:
  - postgres.upstream

{%- endif %}

### Installation states

postgresql-installed:
  pkg.installed:
    - name: {{ postgres.pkg }}
    - refresh: {{ postgres.use_upstream_repo }}

# make sure the data directory and contents have been initialized
postgresql-cluster-prepared:
  cmd.run:
    - name: {{ postgres.prepare_cluster.command }}
    - cwd: /
    - runas: {{ postgres.prepare_cluster.user }}
    - env: {{ postgres.prepare_cluster.env|default({}) }}
    - unless:
      - {{ postgres.prepare_cluster.test }}
    - require:
      - pkg: postgresql-installed

postgresql-config-dir:
  file.directory:
    - name: {{ postgres.conf_dir }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - makedirs: True
    - require:
      - cmd: postgresql-cluster-prepared

{%- if postgres.postgresconf %}

postgresql-conf:
  file.blockreplace:
    - name: {{ postgres.conf_dir }}/postgresql.conf
    - marker_start: "# Managed by SaltStack: listen_addresses: please do not edit"
    - marker_end: "# Managed by SaltStack: end of salt managed zone --"
    - content: |
        {{ postgres.postgresconf|indent(8) }}
    - show_changes: True
    - append_if_not_found: True
    - backup: {{ postgres.postgresconf_backup }}
    - watch_in:
       - service: postgresql-running
    - require:
      - file: postgresql-config-dir

{%- endif %}

postgresql-pg_hba:
  file.managed:
    - name: {{ postgres.conf_dir }}/pg_hba.conf
    - source: {{ postgres['pg_hba.conf'] }}
    - template: jinja
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - mode: 600
    - require:
      - file: postgresql-config-dir

postgresql-running:
  service.running:
    - name: {{ postgres.service }}
    - enable: True
    - reload: True
    - watch:
      - file: postgresql-pg_hba

postgresql-extra-pkgs-installed:
  pkg.installed:
    - pkgs: {{ postgres.pkgs_extra }}

### User states

{%- for name, user in postgres.users|dictsort() %}

{{ format_state(name, 'postgres_user', user) }}
    - require:
      - service: postgresql-running
  {%- if 'db_user' in user %}
      - postgres_user: postgres_user-{{ user.db_user }}
  {%- endif %}

{%- endfor %}

### Tablespace states

{%- for name, tblspace in postgres.tablespaces|dictsort() %}

postgres_tablespace-dir-{{ tblspace.directory}}:
  file.directory:
    - name: {{ tblspace.directory }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - mode: 700
    - makedirs: True
    - recurse:
      - user
      - group

{{ format_state(name, 'postgres_tablespace', tblspace) }}
    - require:
      - file: postgres_tablespace-dir-{{ tblspace.directory }}
  {%- if 'owner' in tblspace %}
      - postgres_user: postgres_user-{{ tblspace.owner }}
  {%- endif %}
      - service: postgresql-running

{%- endfor %}

### Database states

{%- for name, db in postgres.databases|dictsort() %}

{{ format_state(name, 'postgres_database', db) }}
    - require:
      - service: postgresql-running
  {%- if 'db_user' in db %}
      - postgres_user: postgres_user-{{ db.db_user }}
  {%- endif %}
  {%- if 'owner' in db %}
      - postgres_user: postgres_user-{{ db.owner }}
  {%- endif %}
  {%- if 'tablespace' in db %}
      - postgres_tablespace: postgres_tablespace-{{ db.tablespace }}
  {%- endif %}

{%- endfor %}

### Schema states

{%- for name, schema in postgres.schemas|dictsort() %}

{{ format_state(name, 'postgres_schema', schema) }}
    - require:
      - service: postgresql-running
  {%- if 'db_user' in schema %}
      - postgres_user: postgres_user-{{ schema.db_user }}
  {%- endif %}
  {%- if 'dbname' in schema %}
      - postgres_database: postgres_database-{{ schema.dbname }}
  {%- endif %}
  {%- if 'owner' in schema %}
      - postgres_user: postgres_user-{{ schema.owner }}
  {%- endif %}

{%- endfor %}

### Extension states

{%- for name, extension in postgres.extensions|dictsort() %}

{{ format_state(name, 'postgres_extension', extension) }}
    - require:
      - service: postgresql-running
      - pkg: postgresql-extra-pkgs-installed
  {%- if 'db_user' in extension %}
      - postgres_user: postgres_user-{{ extension.db_user }}
  {%- endif %}
  {%- if 'maintenance_db' in extension %}
      - postgres_database: postgres_database-{{ extension.maintenance_db }}
  {%- endif %}
  {%- if 'schema' in extension %}
      - postgres_schema: postgres_schema-{{ extension.schema }}
  {%- endif %}

{%- endfor %}
