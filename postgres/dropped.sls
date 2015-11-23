{% from "postgres/map.jinja" import postgres with context %}

postgresql-dead:
  service.dead:
    - name: {{ postgres.service }}

postgresql-removed:
  pkg.removed:
    - pkgs:
      {% if postgres.pkg %}
      - {{ postgres.pkg }}
      {% endif %}
      {% if postgres.pkg_client %}
      - {{ postgres.pkg_client }}
      {% endif %}
      {% if postgres.pkg_dev %}
      - {{ postgres.pkg_dev }}
      {% endif %}
      {% if postgres.pkg_libpq_dev %}
      - {{ postgres.pkg_libpq_dev }}
      {% endif %}
      {% if postgres.pkgs_extra %}
      {% for pkg in postgres.pkgs_extra %}
      - {{ pkg }}
      {% endfor %}
      {% endif %}

postgres-dir-absent:
  file.absent:
    - name: {{ postgres.conf_dir }}
