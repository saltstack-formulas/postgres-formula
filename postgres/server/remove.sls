{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

postgresql-dead:
  service.dead:
    - name: {{ postgres.service.name }}
    - enable: False

postgresql-repo-removed:
  pkgrepo.absent:
    - name: {{ postgres.pkg_repo.name }}
    {%- if 'pkg_repo_keyid' in postgres %}
    - keyid: {{ postgres.pkg_repo_keyid }}
    {%- endif %}

#remove release installed by formula
postgresql-server-removed:
  pkg.removed:
    - pkgs:
      {% if postgres.pkg %}
      - {{ postgres.pkg }}
      {% endif %}
      {% if postgres.pkgs_extra %}
      {% for pkg in postgres.pkgs_extra %}
      - {{ pkg }}
      {% endfor %}
      {% endif %}

{%- if postgres.remove.multiple_releases %}
    #search for and cleandown multiple releases

  {% for release in postgres.remove.releases %}
postgresql{{ release }}-server-pkgs-removed:
  pkg.purged:
    - pkgs:
      - {{ postgres.pkg if postgres.pkg else "postgresql" }}
      - postgresql-server
      - postgresql-libs
      - postgresql-contrib
      - postgresql-server-{{ release }}
      - postgresql-libs-{{ release }}
      - postgresql-contrib-{{ release }}
      - postgresql{{ release }}-contrib
      - postgresql{{ release }}-server
      - postgresql{{ release }}-libs
      - postgresql{{ release }}-contrib
      - postgresql{{ release|replace('.', '') }}-contrib
      - postgresql{{ release|replace('.', '') }}-server
      - postgresql{{ release|replace('.', '') }}-libs
      - postgresql{{ release|replace('.', '') }}-contrib

    {% if 'bin_dir' in postgres %}
      {% for bin in postgres.server_bins %}
        {% set path = '/usr/pgsql-' + release|string + '/bin/' + bin %}

postgresql{{ release }}-server-{{ bin }}-alternative-remove:
  alternatives.remove:
    - name: {{ bin }}
    - path: {{ path }}
      {% if grains.os in ('Fedora', 'CentOS',) %}
      {# bypass bug #}
    - onlyif: alternatives --display {{ bin }}
      {% else %}
    - onlyif: test -f {{ path }}
      {% endif %}

      {% endfor %}
    {% endif %}

    {%- if postgres.remove.data %}
      #allow data loss? default is no
postgresql{{ release }}-dataconf-removed:
  file.absent:
    - names:
      - {{ postgres.conf_dir }}
      - {{ postgres.data_dir }}
      - /var/lib/postgresql
      - /var/lib/pgsql

      {% for name, tblspace in postgres.tablespaces|dictsort() %}
postgresql{{ release }}-tablespace-dir-{{ name }}-removed:
  file.absent:
    - name: {{ tblspace.directory }}
    - require:
      - file: postgresql{{ release }}-dataconf-removed
      {% endfor %}
    {% endif %}

  {% endfor %}
{%- endif %}
