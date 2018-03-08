{% from "postgres/map.jinja" import postgres with context %}

include:
{% if postgres.use_upstream_repo == 'postgresapp' %}
  - postgres.macos.postgresapp
{% else %}
  - postgres.server
  - postgres.client
{% endif %}
  - postgres.dev
