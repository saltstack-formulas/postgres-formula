{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

# remove release installed by formula
postgresql-devel-removed:
  pkg.removed:
    - pkgs:
      {% if postgres.pkg_dev %}
      - {{ postgres.pkg_dev }}
      {% endif %}
      {% if postgres.pkg_libpq_dev %}
      - {{ postgres.pkg_libpq_dev }}
      {% endif %}
      {% if postgres.pkg_python %}
      - {{ postgres.pkg_python }}
      {% endif %}

{%- if postgres.remove.multiple_releases %}
    #search for and cleandown multiple releases

  {% for release in postgres.remove.releases %}
    {% if 'bin_dir' in postgres %}
      {%- for bin in postgres.dev_bins %}
        {% set path = '/usr/pgsql-' + release|string + '/bin/' + bin %}

postgresql{{ release }}-devel-{{ bin }}-alternative-remove:
  alternatives.remove:
    - name: {{ bin }}
    - path: {{ path }}
        {% if grains.os in ('Fedora', 'CentOS',) %}
        {# bypass bug #}
    - onlyif: alternatives --display {{ bin }}
        {% else %}
    - onlyif: test -f {{ path }}
        {% endif %}
    - require_in:
      - pkg: postgresql{{ release }}-devel-pkgs-removed
      {%- endfor %}
    {%- endif %}

postgresql{{ release }}-devel-pkgs-removed:
  pkg.purged:
    - pkgs:
      - postgresql-dev
      - postgresql-dev-{{ release|replace('.', '') }}
      - postgresql-server-dev
      - postgresql-server-dev-{{ release|replace('.', '') }}
      - postgresql{{ release }}-jdbc
      - postgresql{{ release|replace('.', '') }}-jdbc
      - postgresql-{{ release }}
      - postgresql-{{ release|replace('.', '') }}
      - {{ postgres.pkg_python or "postgresql-python" }}

  {% endfor %}

{%- endif %}
