{%- from tpldir + "/map.jinja" import postgres with context -%}
{%- from tpldir + "/macros.jinja" import format_state with context -%}

{%- set needs_client_binaries = salt['postgres.user_create']|default(none) is not callable -%}

{%- if needs_client_binaries %}

# Salt states for managing PostgreSQL is not available,
# need to provision client binaries first

include:
  - postgres.client
  {%- if 'server_bins' in postgres and grains['saltversion'] == '2016.11.0' %}
  # FIXME: Salt v2016.11.0 bug https://github.com/saltstack/salt/issues/37935
  - postgres.server
  {%- endif %}

{%- endif %}

# Ensure that Salt is able to use postgres modules

postgres-reload-modules:
  test.configurable_test_state:
    - changes:
      {%- if needs_client_binaries or postgres.manage_force_reload_modules %} True
      {%- else %} False
      {%- endif %}
    - result: True
    - reload_modules: True

# User states

{%- for name, user in postgres.users|dictsort() %}

{{ format_state(name, 'postgres_user', user) }}

{%- endfor %}

# Tablespace states

{%- for name, tblspace in postgres.tablespaces|dictsort() %}

{{ format_state(name, 'postgres_tablespace', tblspace) }}
  {%- if 'owner' in tblspace %}
{#- - require: #}
      - postgres_user: postgres_user-{{ tblspace.owner }}
  {%- endif %}

{%- endfor %}

# Database states

{%- for name, db in postgres.databases|dictsort() %}
  {%- if 'extensions' in db %}
    {%- for ext_name, extension in db.pop('extensions')|dictsort() %}
      {%- do extension.update({'name': ext_name, 'maintenance_db': name}) %}

{{ format_state( name + '-' + ext_name, 'postgres_extension', extension) }}
{#- - require: #}
      - postgres_database: postgres_database-{{ name }}
      {%- if 'schema' in extension and 'schemas' in postgres %}
      - postgres_schema: postgres_schema-{{ name }}-{{ extension.schema }}
      {%- endif %}

    {%- endfor %}
  {%- endif %}
  {%- if 'schemas' in db %}
    {%- for schema_name, schema in db.pop('schemas')|dictsort() %}
      {%- do schema.update({'name': schema_name, 'dbname': name }) %}

{{ format_state( name + '-' + schema_name, 'postgres_schema', schema) }}
{#- - require: #}
      - postgres_database: postgres_database-{{ name }}

    {%- endfor %}
  {%- endif %}

{{ format_state(name, 'postgres_database', db) }}
  {%- if 'owner' in db or 'tablespace' in db %}
{#- - require: #}
  {%- endif %}
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
{#- - require: #}
      - postgres_database-{{ schema.dbname }}
  {%- if 'owner' in schema %}
      - postgres_user: postgres_user-{{ schema.owner }}
  {%- endif %}

{%- endfor %}

# Extension states

{%- for name, extension in postgres.extensions|dictsort() %}

{{ format_state(name, 'postgres_extension', extension) }}
{#- - require: #}
  {%- if 'maintenance_db' in extension %}
      - postgres_database: postgres_database-{{ extension.maintenance_db }}
  {%- endif %}
  {%- if 'schema' in extension %}
      - postgres_schema: postgres_schema-{{ extension.schema }}
  {%- endif %}

{%- endfor %}
