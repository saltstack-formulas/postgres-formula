{%- from "postgres/map.jinja" import postgres with context -%}
{%- from "postgres/macros.jinja" import format_state with context -%}

{%- if salt['postgres.user_create']|default(none) is not callable %}

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
  test.nop:
    - reload_modules: True

# User states

{%- for name, user in postgres.users|dictsort() %}

{{ format_state(name, 'postgres_user', user) }}
    - require:
      - test: postgres-reload-modules

{%- endfor %}

# Tablespace states

{%- for name, tblspace in postgres.tablespaces|dictsort() %}

{{ format_state(name, 'postgres_tablespace', tblspace) }}
    - require:
      - test: postgres-reload-modules
  {%- if 'owner' in tblspace %}
      - postgres_user: postgres_user-{{ tblspace.owner }}
  {%- endif %}

{%- endfor %}

# Database states

{%- for name, db in postgres.databases|dictsort() %}

{{ format_state(name, 'postgres_database', db) }}
    - require:
      - test: postgres-reload-modules
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
      - test: postgres-reload-modules
  {%- if 'owner' in schema %}
      - postgres_user: postgres_user-{{ schema.owner }}
  {%- endif %}

{%- endfor %}

# Extension states

{%- for name, extension in postgres.extensions|dictsort() %}

{{ format_state(name, 'postgres_extension', extension) }}
    - require:
      - test: postgres-reload-modules
  {%- if 'maintenance_db' in extension %}
      - postgres_database: postgres_database-{{ extension.maintenance_db }}
  {%- endif %}
  {%- if 'schema' in extension %}
      - postgres_schema: postgres_schema-{{ extension.schema }}
  {%- endif %}

{%- endfor %}
