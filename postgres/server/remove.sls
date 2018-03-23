{%- from "postgres/map.jinja" import postgres with context %}

{%- if 'pkg_repo' in postgres -%}
  {%- if postgres.use_upstream_repo -%}
    {## Remove the repo ##}
postgresql-repo-removed:
  pkgrepo.absent:
    - name: {{ postgres.pkg_repo.name }}
    {%- if 'pkg_repo_keyid' in postgres %}
    - keyid: {{ postgres.pkg_repo_keyid }}
    {%- endif %}
    - require_in:
      - pkg: postgresql-server-removed
  {%- endif -%}
{%- endif -%}

{%- if not postgres.bake_image %}
# Stop PostgreSQL service with OS init
postgresql-dead:
  service.dead:
    - name: {{ postgres.service }}
    - enable: False
{%- endif %}

# Remove PostgreSQL server packages
postgresql-server-removed:
  pkg.purged:
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
      {% if postgres.pkg_libs %}
      - {{ postgres.pkg_libs }}
      {% endif %}
     {# sometimes postgres-init remains. Maybe systemd.service related? #}
      - postgres-init
      - postgres-contrib
     {# postgres-common remains on Ubuntu #}
      - postgresql-common
      - postgresql-jdbc
     {# upstream package repos #}
  {%- for version in ['', '92', '93', '94', '95', '96', '10',] %}
      - postgresql{{ version }}-server
      - postgresql{{ version }}-server
      - postgresql{{ version }}
      - postgresql{{ version }}-libs
      - postgresql{{ version }}-contrib
  {%- endfor %}

{%- if 'bin_dir' in postgres %}
  {%- for bin in postgres.server_bins %}
    {%- for version in ['9.2', '9.3', '9.4', '9.5', '9.6', '10',] %}
      {%- set path = salt['file.join']('/usr/pgsql-{{ version }}/bin/', bin) %}

postgresql{{ version }}-{{ bin }}-altremove:
  alternatives.remove:
    - name: postgresql-{{ bin }}
    - path: {{ path }}
    - require:
      - pkg: postgresql-server-removed
    - onlyif: test -f {{ path }}

    {%- endfor %}
  {%- endfor %}
{%- endif %}

postgresql-dataconf-removed:
  file.absent:
    - names:
      - {{ postgres.conf_dir }}
      - {{ postgres.data_dir }}
      - /var/lib/postgresql
      - /var/lib/pgsql

  {%- for name, tblspace in postgres.tablespaces|dictsort() %}
postgresql-tablespace-dir-{{ name }}-removed:
  file.absent:
    - name: {{ tblspace.directory }}
    - require:
      - file: postgresql-dataconf-removed
  {% endfor %}

