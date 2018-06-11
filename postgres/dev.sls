{% from tpldir + "/map.jinja" import postgres with context %}

{% if grains.os not in ('Windows', 'MacOS',) %}

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

# Alternatives system. Make devclient binaries available in $PATH
  {%- if 'bin_dir' in postgres and postgres.linux.altpriority %}
    {%- for bin in postgres.dev_bins %}
      {%- set path = salt['file.join'](postgres.bin_dir, bin) %}

postgresql-{{ bin }}-altinstall:
  alternatives.install:
    - name: {{ bin }}
    - link: {{ salt['file.join']('/usr/bin', bin) }}
    - path: {{ path }}
    - priority: {{ postgres.linux.altpriority }}
    - onlyif: test -f {{ path }}

    {%- endfor %}
  {%- endif %}

{% elif grains.os == 'MacOS' %}

  # Darwin maxfiles limits
  {% if postgres.limits.soft or postgres.limits.hard %}

postgres_maxfiles_limits_conf:
  file.managed:
    - name: /Library/LaunchDaemons/limit.maxfiles.plist
    - source: salt://{{ tpldir }}/templates/limit.maxfiles.plist
    - template: jinja
    - context:
      soft_limit: {{ postgres.limits.soft }}
      hard_limit: {{ postgres.limits.hard }}
    - group: {{ postgres.group }}
  {% endif %}

  {% if postgres.use_upstream_repo == 'postgresapp' %}
  # Shortcut for PostgresApp
postgres-desktop-shortcut-clean:
  file.absent:
    - name: '{{ postgres.userhomes }}/{{ postgres.user }}/Desktop/Postgres ({{ postgres.use_upstream_repo }})'
    - require_in:
      - file: postgres-desktop-shortcut-add

postgres-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://{{ tpldir }}/templates/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ postgres.user }}
      homes: {{ postgres.userhomes }}
  cmd.run:
    - name: '/tmp/mac_shortcut.sh "Postgres ({{ postgres.use_upstream_repo }})"'
    - runas: {{ postgres.user }}
    - require:
      - file: postgres-desktop-shortcut-add
  {% endif %}

{% endif %}
