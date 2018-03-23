{%- from "postgres/map.jinja" import postgres with context -%}

# Remove Postgres client and dev packages
postgresql-client-dev-removed:
  pkg.purged:
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
      {% if postgres.pkg_python %}
      - {{ postgres.pkg_python }}
      {% endif %}
      {# these packages probably should go too #}
      - postgresql-common
      - postgresql-client-common
      - libpostgresql-jdbc-java
  {%- for version in ['', '92', '93', '94', '95', '96', '10',] %}
      - postgresql{{ version }}
  {%- endfor %}

postgresql-etc-removed:
  file.absent:
    - names:
      - /etc/postgresql
