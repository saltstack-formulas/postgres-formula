{%- from "postgres/map.jinja" import postgres with context -%}
{%- from "postgres/macros.jinja" import format_state with context -%}
{%- from "postgres/macros.jinja" import format_kwargs with context -%}

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

 {%- do user.update({'name': name}) %}
{{ format_state(name, 'postgres_user', user) }}
    - require:
      - test: postgres-reload-modules

{%- endfor %}

# Tablespace states

{%- for name, tblspace in postgres.tablespaces|dictsort() %}
 {%- do tblspace.update({'name': name}) %}

{{ format_state(name, 'postgres_tablespace', tblspace) }}
    - require:
      - test: postgres-reload-modules
  {%- if 'owner' in tblspace %}
      - postgres_user: postgres_user-{{ tblspace.owner }}
  {%- endif %}

{%- endfor %}

# Database states

{%- macro format_database(db_name, kwarg) %}

  {%- do kwarg.update({'name': db_name}) %}
  {%- if 'ensure' in kwarg %}
    {%- set ensure = kwarg.pop('ensure') %}
  {%- endif %}
  {%- if 'user' not in kwarg %}
    {%- do kwarg.update({'user': postgres.user}) %}
  {%- endif %}

  {# extract any extensions or schemas #}
  {%- if 'schemas' in kwarg %}
    {%- set schemas = kwarg.pop('schemas') %}
  {%- else %}
    {%- set schemas = {} %}
  {%- endif %}


postgres_database-{{ db_name }}:
  postgres_database.{{ ensure|default('present') }}:
  {{- format_kwargs(kwarg) }}
    - require:
      - test: postgres-reload-modules
    {%- if 'owner' in kwarg %}
      - postgres_user: postgres_user-{{ kwarg.owner }}
    {%- endif %}
    {%- if 'tablespace' in kwarg %}
      - postgres_tablespace: postgres_tablespace-{{ kwarg.tablespace }}
    {% endif %}

{# per db schemas #}
{%- for schema_name, schema in schemas|dictsort() %}

  {%- do schema.update({'dbname': db_name, 'name': schema_name}) %}
  {# multiple databases can have a schema with the same name #}
  {%- set schema_salt_state_suffix = db_name ~ '-' ~ schema_name %}
  {%- if 'extensions' in schema %}
    {%- set extensions = schema.pop('extensions') %}
  {%- else %}
    {%- set extensions = {} %}
  {%- endif %}

{{ format_state(schema_salt_state_suffix, 'postgres_schema', schema) }}
    - require:
      - test: postgres-reload-modules
      - postgres_database: postgres_database-{{ db_name }}
  {%- if 'owner' in schema %}
      - postgres_user: postgres_user-{{ schema.owner }}
  {%- endif %}

  {# per schema extensions #}
  {%- for extension in extensions %}


    {# multiple databases can use the same extension #}
postgres_extension-{{ db_name }}-{{ extension }}:
  postgres_extension.present:
    - schema: {{ schema_name }}
    - maintenance_db: {{ db_name }}
    - name: {{ extension }}
    - require:
      - test: postgres-reload-modules
      - postgres_database: postgres_database-{{ db_name }}
      - postgres_schema: postgres_schema-{{ schema_salt_state_suffix }}

  {%- endfor %}

{%- endfor %}

{%- endmacro %}

{%- for name, db in postgres.databases|dictsort() %}

{{ format_database(name, db) }}

{%- endfor %}
