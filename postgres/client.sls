{% from "postgres/map.jinja" import postgres with context %}

{% if salt['pillar.get']('postgres:use_upstream_repo') %}
install-postgresql-repo:
  pkgrepo.managed:
    - humanname: PostgreSQL Official Repository
    - name: {{ postgres.pkg_repo }}
    - keyid: B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - file: {{ postgres.pkg_repo_file }}
    - require_in:
        - install-postgresql-client
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
