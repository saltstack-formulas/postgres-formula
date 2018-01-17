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
      {% if postgres.pkg_libs %}
      - {{ postgres.pkg_libs }}
      {% endif %}
      {% if postgres.pkg_contrib %}
      - {{ postgres.pkg_contrib }}
      {% endif %}
     {# sometimes postgres-init remains. Maybe systemd.service related? #}
      - postgres-init
     {# postgres-common remains on Ubuntu #}
      - postgresql-common
     {# oldest upstream version can be removed #}
      - postgresql95-server
      - postgresql95
      - postgresql-jdbc
      - postgresql95-libs
      - postgresql95-contrib

{%- if 'bin_dir' in postgres %}
  {%- for bin in postgres.server_bins %}
    {%- set path = salt['file.join'](postgres.bin_dir, bin) %}

postgresql-{{ bin }}-removed:
  alternatives.remove:
    - link: {{ salt['file.join']('/usr/bin', bin) }}
    - path: {{ path }}
    - require:
      - pkg: postgresql-server-removed

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
postgresql-tablespace-dir-{{ name }}:
  file.absent:
    - name: {{ tblspace.directory }}
    - onchanges:
      - file: postgresql-dataconf-removed
    - require:
      - file: postgresql-dataconf-removed
  {% endfor %}
