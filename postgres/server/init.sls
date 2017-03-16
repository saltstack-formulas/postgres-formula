{%- from "postgres/map.jinja" import postgres with context %}

{%- set includes = [] %}
{%- if postgres.bake_image %}
  {%- do includes.append('postgres.server.image') %}
{%- endif %}
{%- if postgres.use_upstream_repo -%}
  {%- do includes.append('postgres.upstream') %}
{%- endif %}

{%- if includes -%}

include:
  {{ includes|yaml(false)|indent(2) }}

{%- endif %}

{%- set pkgs = [postgres.pkg] + postgres.pkgs_extra %}

# Install, configure and start PostgreSQL server

postgresql-server:
  pkg.installed:
    - pkgs: {{ pkgs }}
{%- if postgres.use_upstream_repo %}
    - refresh: True
    - require:
      - pkgrepo: postgresql-repo
{%- endif %}

{%- if 'bin_dir' in postgres %}

# Make server binaries available in $PATH

  {%- for bin in postgres.server_bins %}

    {%- set path = salt['file.join'](postgres.bin_dir, bin) %}

{{ bin }}:
  alternatives.install:
    - link: {{ salt['file.join']('/usr/bin', bin) }}
    - path: {{ path }}
    - priority: 30
    - onlyif: test -f {{ path }}
    - require:
      - pkg: postgresql-server
    - require_in:
      - cmd: postgresql-cluster-prepared

  {%- endfor %}

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
    {#- Detect empty values (none, '') in the config_backup #}
    - backup: {{ postgres.config_backup|default(false, true) }}
    - require:
      - file: postgresql-config-dir
    - watch_in:
       - service: postgresql-running

{%- endif %}

{%- set pg_hba_path = salt['file.join'](postgres.conf_dir, 'pg_hba.conf') %}

postgresql-pg_hba:
  file.managed:
    - name: {{ pg_hba_path }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - mode: 600
{%- if postgres.acls %}
    - source: {{ postgres['pg_hba.conf'] }}
    - template: jinja
    - defaults:
        acls: {{ postgres.acls }}
  {%- if postgres.config_backup %}
    # Create the empty file before managing to overcome the limitation of check_cmd
    - onlyif: test -f {{ pg_hba_path }} || touch {{ pg_hba_path }}
    # Make a local backup before the file modification
    - check_cmd: >-
        salt-call --local file.copy
        {{ pg_hba_path }} {{ pg_hba_path ~ postgres.config_backup }} remove_existing=true
  {%- endif %}
{%- else %}
    - replace: False
{%- endif %}
    - require:
      - file: postgresql-config-dir

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
    - require:
      - pkg: postgresql-server

{%- endfor %}

{%- if not postgres.bake_image %}

# Start PostgreSQL server using OS init

postgresql-running:
  service.running:
    - name: {{ postgres.service }}
    - enable: True
    - reload: True
    - watch:
      - file: postgresql-pg_hba

{%- endif %}
