{% from "postgres/map.jinja" import postgres with context %}

{% if salt['pillar.get']('postgres:use_upstream_repo') %}
install-postgresql-repo:
  pkgrepo.managed:
    - humanname: PostgreSQL Official Repository
    - name: {{ postgres.pkg_repo }}
    - keyid: B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - file: {{ postgres.pkg_repo_file }}
    - require_in:
        - install-postgresql
{% endif %}

install-postgresql:
  pkg.installed:
    - name: {{ postgres.pkg }}
    - refresh: {{ salt['pillar.get']('postgres:use_upstream_repo', False) }}

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

{% if postgres.pkg_dev != False %}
install-postgres-dev-package:
  pkg.installed:
    - name: {{ postgres.pkg_dev }}
{% endif %}

{% if postgres.pkg_libpq_dev != False %}
install-postgres-libpq-dev:
  pkg.installed:
    - name: {{ postgres.pkg_libpq_dev }}
{% endif %}

{% if postgres.pkg_contrib != False %}
install-postgres-contrib:
  pkg.installed:
    - name: {{ postgres.pkg_contrib }}
{% endif %}

{% if 'postgresconf' in pillar.get('postgres', {}) %}
postgresql-conf:
  file.blockreplace:
    - name: {{ postgres.conf_dir }}/postgresql.conf
    - marker_start: "# Managed by SaltStack: listen_addresses: please do not edit"
    - marker_end: "# Managed by SaltStack: end of salt managed zone --"
    - content: |
        {{ salt['pillar.get']('postgres:postgresconf') | indent(8) }}
    - show_changes: True
    - append_if_not_found: True
    - watch_in:
       - service: postgresql
{% endif %}

{% if 'pg_hba.conf' in pillar.get('postgres', {}) %}
pg_hba.conf:
  file.managed:
    - name: {{ postgres.conf_dir }}/pg_hba.conf
    - source: {{ salt['pillar.get']('postgres:pg_hba.conf', 'salt://postgres/pg_hba.conf') }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: postgresql
{% endif %}

{% if 'users' in pillar.get('postgres', {}) %}
{% for name, user in salt['pillar.get']('postgres:users').items()  %}
postgres-user-{{ name }}:
  postgres_user.present:
    - name: {{ name }}
    - createdb: {{ salt['pillar.get']('postgres:users:' + name + ':createdb', False) }}
    - password: {{ salt['pillar.get']('postgres:users:' + name + ':password', 'changethis') }}
    - runas: postgres
    - require:
      - service: {{ postgres.service }}
{% endfor%}
{% endif %}

{% if 'databases' in pillar.get('postgres', {}) %}
{% for name, db in salt['pillar.get']('postgres:databases').items()  %}
postgres-db-{{ name }}:
  postgres_database.present:
    - name: {{ name }}
    - encoding: {{ salt['pillar.get']('postgres:databases:'+ name +':encoding', 'UTF8') }}
    - lc_ctype: {{ salt['pillar.get']('postgres:databases:'+ name +':lc_ctype', 'en_US.UTF8') }}
    - lc_collate: {{ salt['pillar.get']('postgres:databases:'+ name +':lc_collate', 'en_US.UTF8') }}
    - template: {{ salt['pillar.get']('postgres:databases:'+ name +':template', 'template0') }}
    {% if salt['pillar.get']('postgres:databases:'+ name +':owner') %}
    - owner: {{ salt['pillar.get']('postgres:databases:'+ name +':owner') }}
    {% endif %}
    - runas: {{ salt['pillar.get']('postgres:databases:'+ name +':runas', 'postgres') }}
    {% if salt['pillar.get']('postgres:databases:'+ name +':user') %}
    - require:
        - postgres_user: postgres-user-{{ salt['pillar.get']('postgres:databases:'+ name +':user') }}
    {% endif %}
{% endfor%}
{% endif %}
