{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

include:
{% if postgres.use_upstream_repo == 'postgresapp' %}
  - postgres.macos.postgresapp
{% elif postgres.use_upstream_repo == 'homebrew' %}
  - postgres.server
  - postgres.client
{% endif %}
  - postgres.dev
