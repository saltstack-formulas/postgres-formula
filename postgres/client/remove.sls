{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

#remove release installed by formula
postgresql-client-removed:
  pkg.removed:
    - pkgs:
      {% if postgres.pkg_client %}
      - {{ postgres.pkg_client }}
      {% endif %}

{%- if postgres.remove.multiple_releases %}
    #search for and cleandown multiple releases

  {% for release in postgres.remove.releases %}
    {% if 'bin_dir' in postgres %}
      {%- for bin in postgres.client_bins %}
        {% set path = '/usr/pgsql-' + release|string + '/bin/' + bin %}

postgresql{{ release }}-client-{{ bin }}-alternative-remove:
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
      - pkg: postgresql{{ release }}-client-pkgs-removed
      {%- endfor %}
    {%- endif %}

postgresql{{ release }}-client-pkgs-removed:
  pkg.purged:
    - pkgs:
      - postgresql
      - postgresql-{{ release }}
      - postgresql-{{ release|replace('.', '') }}
      - postgresql{{ release }}-common
      - postgresql{{ release }}-jdbc

  {% endfor %}

{%- endif %}
