{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

{%- set includes = [] %}
{%- if postgres.bake_image %}
  {%- do includes.append('postgres.server.image') %}
{%- endif %}
{%- if postgres.use_upstream_repo == true -%}
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
{%- if postgres.use_upstream_repo == true %}
    - refresh: True
    - require:
      - pkgrepo: postgresql-repo
{%- endif %}
  {%- if postgres.fromrepo %}
    - fromrepo: {{ postgres.fromrepo }}
  {%- endif %}
  {%- if grains.os == 'MacOS' %}
     #Register as Launchd LaunchAgent for system users
    - require_in:
      - file: postgresql-server
  file.managed:
    - name: /Library/LaunchAgents/{{ postgres.service }}.plist
    - source: /usr/local/opt/postgres/{{ postgres.service }}.plist
    - group: wheel
    - require_in:
      - service: postgresql-running


# Alternatives system. Make server binaries available in $PATH
  {%- elif 'bin_dir' in postgres and postgres.linux.altpriority %}
      {%- for bin in postgres.server_bins %}
        {%- set path = salt['file.join'](postgres.bin_dir, bin) %}

postgresql-{{ bin }}-altinstall:
  alternatives.install:
    - name: {{ bin }}
    - link: {{ salt['file.join']('/usr/bin', bin) }}
    - path: {{ path }}
    - priority: {{ postgres.linux.altpriority }}
    - onlyif: test -f {{ path }}
    - require:
      - pkg: postgresql-server
    - require_in:
      - cmd: postgresql-cluster-prepared

      {%- endfor %}
  {%- endif %}

postgresql-cluster-prepared:
  file.directory:
    - name: {{ postgres.data_dir }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - makedirs: True
    - recurse:
      - user
      - group
  cmd.run:
 {%- if postgres.prepare_cluster.command is defined %}
      {# support for depreciated 'prepare_cluster.command' pillar #}
    - name: {{ postgres.prepare_cluster.command }}
    - unless: {{ postgres.prepare_cluster.test }}
 {%- else %}
    - name: {{ postgres.prepare_cluster_cmd }}
    - unless: test -f {{ postgres.data_dir }}/{{ postgres.prepare_cluster.pgtestfile }}
 {%- endif %}
    - cwd: /
    - env: {{ postgres.prepare_cluster.env }}
    - runas: {{ postgres.prepare_cluster.user }}
    - require:
      - pkg: postgresql-server
      - file: postgresql-cluster-prepared
    - watch_in:
      - module: postgresql-service-restart

postgresql-config-dir:
  file.directory:
    - names:
      - {{ postgres.data_dir }}
      - {{ postgres.conf_dir }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - dir_mode: {{ postgres.conf_dir_mode }}
    - force: True
    - recurse:
      - mode
      - ignore_files
    - makedirs: True
    - require:
      - cmd: postgresql-cluster-prepared

{%- set db_port = salt['config.option']('postgres.port') %}
{%- if db_port %}

postgresql-conf-comment-port:
  file.comment:
    - name: {{ postgres.conf_dir }}/postgresql.conf
    - regex: ^port\s*=.+
    - require:
      - file: postgresql-config-dir

{%- endif %}

{%- if postgres.postgresconf or db_port %}

postgresql-conf:
  file.blockreplace:
    - name: {{ postgres.conf_dir }}/postgresql.conf
    - marker_start: "# Managed by SaltStack: listen_addresses: please do not edit"
    - marker_end: "# Managed by SaltStack: end of salt managed zone --"
    - content: |
        {%- if postgres.postgresconf %}
        {{ postgres.postgresconf|indent(8) }}
        {%- endif %}
        {%- if db_port %}
        port = {{ db_port }}
        {%- endif %}
    - show_changes: True
    - append_if_not_found: True
    {#- Detect empty values (none, '') in the config_backup #}
    - backup: {{ postgres.config_backup|default(false, true) }}
    - require:
      - file: postgresql-config-dir
      {%- if db_port %}
      - file: postgresql-conf-comment-port
      {%- endif %}
    - watch_in:
      - module: postgresql-service-restart

{%- endif %}

# Restart the service where reloading is not sufficient
# Currently when the cluster is created or changes made to `postgresql.conf`
postgresql-service-restart:
  module.wait:
    - name: service.restart
    - m_name: {{ postgres.service }}

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
        acls: {{ postgres.acls|yaml() }}
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

{%- set pg_ident_path = salt['file.join'](postgres.conf_dir, 'pg_ident.conf') %}

postgresql-pg_ident:
  file.managed:
    - name: {{ pg_ident_path }}
    - user: {{ postgres.user }}
    - group: {{ postgres.group }}
    - mode: 600
{%- if postgres.identity_map %}
    - source: {{ postgres['pg_ident.conf'] }}
    - template: jinja
    - defaults:
        mappings: {{ postgres.identity_map|yaml() }}
  {%- if postgres.config_backup %}
    # Create the empty file before managing to overcome the limitation of check_cmd
    - onlyif: test -f {{ pg_ident_path }} || touch {{ pg_ident_path }}
    # Make a local backup before the file modification
    - check_cmd: >-
        salt-call --local file.copy
        {{ pg_ident_path }} {{ pg_ident_path ~ postgres.config_backup }} remove_existing=true
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
   {% if grains.os not in ('MacOS',) %}
    - reload: True
   {% endif %}
    - watch:
      - file: postgresql-pg_hba
      - file: postgresql-pg_ident

{%- endif %}
