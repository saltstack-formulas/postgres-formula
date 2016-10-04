{%- from "postgres/map.jinja" import postgres with context -%}
{%- from "postgres/macros.jinja" import format_state with context -%}

{%- set pkgs = [] %}
{%- for pkg in (postgres.pkg_client, postgres.pkg_libpq_dev) %}
  {%- if pkg %}
    {%- do pkgs.append(pkg) %}
  {%- endif %}
{%- endfor -%}

{%- if postgres.use_upstream_repo -%}

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

# Ensure that Salt is able to use postgres modules
# after installing client binaries

postgres-reload-modules:
  test.nop:
    - reload_modules: True

# User states

{%- for name, user in postgres.users|dictsort() %}

{{ format_state(name, 'postgres_user', user) }}
    - require:
      - pkg: postgresql-client-libs

{%- endfor %}

# Tablespace states

{%- for name, tblspace in postgres.tablespaces|dictsort() %}

{{ format_state(name, 'postgres_tablespace', tblspace) }}
    - require:
      - pkg: postgresql-client-libs
  {%- if 'owner' in tblspace %}
      - postgres_user: postgres_user-{{ tblspace.owner }}
  {%- endif %}

{%- endfor %}

# Database states

{%- for name, db in postgres.databases|dictsort() %}

{{ format_state(name, 'postgres_database', db) }}
    - require:
      - pkg: postgresql-client-libs
  {%- if 'owner' in db %}
      - postgres_user: postgres_user-{{ db.owner }}
  {%- endif %}
  {%- if 'tablespace' in db %}
      - postgres_tablespace: postgres_tablespace-{{ db.tablespace }}
  {%- endif %}

{%- endfor %}

# Schema states

{%- for name, schema in postgres.schemas|dictsort() %}

{{ format_state(name, 'postgres_schema', schema) }}
    - require:
      - pkg: postgresql-client-libs
  {%- if 'owner' in schema %}
      - postgres_user: postgres_user-{{ schema.owner }}
  {%- endif %}

{%- endfor %}

# Extension states

{%- for name, extension in postgres.extensions|dictsort() %}

{{ format_state(name, 'postgres_extension', extension) }}
    - require:
      - pkg: postgresql-client-libs
  {%- if 'maintenance_db' in extension %}
      - postgres_database: postgres_database-{{ extension.maintenance_db }}
  {%- endif %}
  {%- if 'schema' in extension %}
      - postgres_schema: postgres_schema-{{ extension.schema }}
  {%- endif %}

{%- endfor %}
