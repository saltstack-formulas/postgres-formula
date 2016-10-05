{%- from "postgres/map.jinja" import postgres with context -%}

{%- set pkgs = [postgres.pkg] + postgres.pkgs_extra -%}

{%- if postgres.use_upstream_repo -%}

include:
  - postgres.upstream

{%- endif %}

# Install, configure and start PostgreSQL server

postgresql-server:
  pkg.installed:
    - pkgs: {{ pkgs }}
{%- if postgres.use_upstream_repo %}
    - refresh: True
    - require:
      - pkgrepo: postgresql-repo
{%- endif %}

postgresql-cluster-prepared:
  cmd.run:
    - name: {{ postgres.prepare_cluster.command }}
    - cwd: /
    - runas: {{ postgres.prepare_cluster.user }}
    - env: {{ postgres.prepare_cluster.env|default({}) }}
    - unless:
      - {{ postgres.prepare_cluster.test }}
    - require:
      - pkg: postgresql-server

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
    - require:
      - file: postgresql-config-dir
    - watch_in:
       - service: postgresql-running

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

{%- for name, tblspace in postgres.tablespaces|dictsort() %}

postgresql-tablespace-dir-{{ name }}:
  file.directory:
    - name: {{ tblspace.directory }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - mode: 700
    - makedirs: True
    - recurse:
      - user
      - group

{%- endfor %}
