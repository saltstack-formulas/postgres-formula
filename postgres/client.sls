{%- from "postgres/map.jinja" import postgres with context -%}

{%- set pkgs = [] %}
{%- for pkg in (postgres.pkg_client, postgres.pkg_libpq_dev) %}
  {%- if pkg %}
    {%- do pkgs.append(pkg) %}
  {%- endif %}
{%- endfor %}

{%- if postgres.use_upstream_repo %}

include:
  - postgres.upstream

{%- endif %}

# Install PostgreSQL client and libraries

postgresql-client-libs:
  pkg.installed:
    - pkgs: {{ pkgs }}
{%- if postgres.use_upstream_repo %}
    - refresh: True
    - require:
      - pkgrepo: postgresql-repo
{%- endif %}

{%- if 'bin_dir' in postgres %}

# Make client binaries available in $PATH

  {%- for bin in postgres.client_bins %}

    {%- set path = salt['file.join'](postgres.bin_dir, bin) %}

{{ bin }}:
  alternatives.install:
    - link: {{ salt['file.join']('/usr/bin', bin) }}
    - path: {{ path }}
    - priority: 30
    - onlyif: test -f {{ path }}
    - require:
      - pkg: postgresql-client-libs

  {%- endfor %}

{%- endif %}
