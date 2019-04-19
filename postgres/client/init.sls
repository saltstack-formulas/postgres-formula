{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

{%- set pkgs = [] %}
{%- for pkg in (postgres.pkg_client,) %}
  {%- if pkg %}
    {%- do pkgs.append(pkg) %}
  {%- endif %}
{%- endfor %}

{%- if postgres.use_upstream_repo == true %}
include:
  - postgres.upstream
{%- endif %}

# Install PostgreSQL client and libraries
postgresql-client-libs:
  pkg.installed:
    - pkgs: {{ pkgs | json }}
  {%- if postgres.use_upstream_repo == true %}
    - refresh: True
    - require:
      - pkgrepo: postgresql-repo
  {%- endif %}
  {%- if postgres.fromrepo %}
    - fromrepo: {{ postgres.fromrepo }}
  {%- endif %}

# Alternatives system. Make client binaries available in $PATH
{%- if 'bin_dir' in postgres and postgres.linux.altpriority %}
    {%- for bin in postgres.client_bins %}
      {%- set path = salt['file.join'](postgres.bin_dir, bin) %}

postgresql-{{ bin }}-altinstall:
  alternatives.install:
    - name: {{ bin }}
    - link: {{ salt['file.join']('/usr/bin', bin) }}
    - path: {{ path }}
    - priority: {{ postgres.linux.altpriority }}
    - onlyif: test -f {{ path }}
    - require:
      - pkg: postgresql-client-libs
      {%- if grains['saltversioninfo'] < [2018, 11, 0, 0] %}
    - retry:
        attempts: 2
        until: True
      {%- endif %}

    {%- endfor %}
{%- endif %}
