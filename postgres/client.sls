{% from "postgres/map.jinja" import postgres with context %}

{% if postgres.use_upstream_repo %}
include:
  - postgres.upstream
{% endif %}

install-postgresql-client:
  pkg.installed:
    - name: {{ postgres.pkg_client }}
  {% if postgres.use_upstream_repo %}
    - refresh: {{ postgres.use_upstream_repo }}
    - require:
      - pkgrepo: install-postgresql-repo
  {% endif %}

{% if postgres.pkg_libpq_dev %}
install-postgres-libpq-dev:
  pkg.installed:
    - name: {{ postgres.pkg_libpq_dev }}
{% endif %}
