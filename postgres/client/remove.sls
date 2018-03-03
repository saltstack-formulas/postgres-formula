{%- from "postgres/map.jinja" import postgres with context -%}

# Remove Postgres client and dev packages
postgresql-client-dev-removed:
  pkg.removed:
    - pkgs:
      {% if postgres.pkg_client %}
      - {{ postgres.pkg_client }}
      {% endif %}
      {% if postgres.pkg_dev %}
      - {{ postgres.pkg_dev }}
      {% endif %}
      {% if postgres.pkg_libpq_dev %}
      - {{ postgres.pkg_libpq_dev }}
      {% endif %}
      {% if postgres.python %}
      - {{ postgres.python }}
      {% endif %}
      {# these packages probably should go too #}
      - postgresql-client-common
      - libpostgresql-jdbc-java
