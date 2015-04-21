{% from "postgres/map.jinja" import postgres with context %}

{% if salt['pillar.get']('postgres:use_upstream_repo') %}
include:
  - postgres.upstream
{% endif %}

install-postgresql-client:
  pkg.installed:
    - name: {{ postgres.pkg_client }}
    - refresh: {{ salt['pillar.get']('postgres:use_upstream_repo', False) }}

{% if postgres.pkg_libpq_dev != False %}
install-postgres-libpq-dev:
  pkg.installed:
    - name: {{ postgres.pkg_libpq_dev }}
{% endif %}
