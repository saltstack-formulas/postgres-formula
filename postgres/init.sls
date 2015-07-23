{% from "postgres/map.jinja" import postgres with context %}

{% if postgres.use_upstream_repo %}
include:
  - postgres.upstream
{% endif %}

install-postgresql:
  pkg.installed:
    - name: {{ postgres.pkg }}
    - refresh: {{ postgres.use_upstream_repo }}

{% if postgres.create_cluster != False %}
create-postgresql-cluster:
  cmd.run:
    - cwd: /
    - user: root
    - name: pg_createcluster {{ postgres.version }} main --start
    - unless: test -f {{ postgres.conf_dir }}/postgresql.conf
    - env:
      LC_ALL: C.UTF-8
{% endif %}

{% if postgres.init_db != False %}
postgresql-initdb:
  cmd.run:
    - cwd: /
    - user: root
    - name: service postgresql initdb
    - unless: test -f {{ postgres.conf_dir }}/postgresql.conf
    - env:
      LC_ALL: C.UTF-8
{% endif %}

run-postgresql:
  service.running:
    - enable: true
    - name: {{ postgres.service }}
    - require:
      - pkg: {{ postgres.pkg }}

{% if postgres.pkg_contrib != False %}
install-postgres-contrib:
  pkg.installed:
    - name: {{ postgres.pkg_contrib }}
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
    - watch_in:
       - service: postgresql
{% endif %}

pg_hba.conf:
  file.managed:
    - name: {{ postgres.conf_dir }}/pg_hba.conf
    - source: {{ postgres['pg_hba.conf'] }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: postgresql

{% for name, user in postgres.users.items()  %}
postgres-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
    - createdb: {{ user.get('createdb', False) }}
    - createroles: {{ user.get('createroles', False) }}
    - createuser: {{ user.get('createuser', False) }}
    - inherit: {{ user.get('inherit', True) }}
    - replication: {{ user.get('replication', False) }}
    - password: {{ user.get('password', 'changethis') }}
    - user: {{ user.get('runas', 'postgres') }}
    - require:
      - service: {{ postgres.service }}
{% endfor%}

{% for name, db in postgres.databases.items()  %}
postgres-db-{{ name }}:
  postgres_database.present:
    - name: {{ name }}
    - encoding: {{ db.get('encoding', 'UTF8') }}
    - lc_ctype: {{ db.get('lc_ctype', 'en_US.UTF8') }}
    - lc_collate: {{ db.get('lc_collate', 'en_US.UTF8') }}
    - template: {{ db.get('template', 'template0') }}
    {% if db.get('owner') %}
    - owner: {{ db.get('owner') }}
    {% endif %}
    - user: {{ db.get('runas', 'postgres') }}
    {% if db.get('user') %}
    - require:
        - postgres_user: postgres-user-{{ db.get('user') }}
    {% endif %}

{% if db.extensions is defined %}
{% for ext in db.extensions %}
postgres-ext-{{ ext }}-for-db-{{ name }}:
  postgres_extension.present:
    - name: {{ ext }}
    - user: {{ db.get('runas', 'postgres') }}
    - maintenance_db: {{ name }}
{% endfor %}
{% endif %}
{% endfor%}

{% for name, directory in postgres.tablespaces.items()  %}
postgres-tablespace-dir-perms-{{ directory}}:
  file.directory:
    - name: {{ directory }}
    - user: postgres
    - group: postgres
    - makedirs: True
    - recurse:
      - user
      - group

postgres-tablespace-{{ name }}:
  postgres_tablespace.present:
    - name: {{ name }}
    - directory: {{ directory }}
    - require:
      - service: {{ postgres.service }}
{% endfor%}
