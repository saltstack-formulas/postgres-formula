{% from "postgres/map.jinja" import postgres with context %}

  {% if postgres.pkg_dev %}
install-postgres-dev-package:
  pkg.installed:
    - name: {{ postgres.pkg_dev }}
    {% if postgres.fromrepo %}
    - fromrepo: {{ postgres.fromrepo }}
    {% endif %}
  {% endif %}

  {% if postgres.pkg_libpq_dev %}
install-postgres-libpq-dev:
  pkg.installed:
    - name: {{ postgres.pkg_libpq_dev }}
    {% if postgres.fromrepo %}
    - fromrepo: {{ postgres.fromrepo }}
    {% endif %}
  {% endif %}
