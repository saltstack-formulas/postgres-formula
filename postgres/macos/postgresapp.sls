{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres as pg with context -%}

# Cleanup first
pg-remove-prev-archive:
  file.absent:
    - name: '{{ pg.macos.tmpdir }}/{{ pg.macos.archive }}'
    - require_in:
      - pg-extract-dirs

pg-extract-dirs:
  file.directory:
    - names:
      - '{{ pg.macos.tmpdir }}'
    - makedirs: True
    - clean: True
    - require_in:
      - pg-download-archive

pg-download-archive:
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl {{ pg.macos.dl.opts }} -o '{{ pg.macos.tmpdir }}/{{ pg.macos.archive }}' {{ pg.macos.postgresapp.url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ pg.macos.dl.retries }}
        interval: {{ pg.macos.dl.interval }}
      {% endif %}

  {%- if pg.macos.postgresapp.sum %}
pg-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ pg.macos.tmpdir }}/{{ pg.macos.archive }}'
     - file_hash: {{ pg.macos.postgresapp.sum }}
     - onchanges:
       - cmd: pg-download-archive
     - require_in:
       - archive: pg-package-install
  {%- endif %}

pg-package-install:
  macpackage.installed:
    - name: '{{ pg.macos.tmpdir }}/{{ pg.macos.archive }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: pg-download-archive
    - require_in:
      - file: pg-package-install
      - file: pg-remove-archive
  file.append:
    - name: {{ pg.userhomes }}/{{ pg.user }}/.bash_profile
    - text: 'export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin'

pg-remove-archive:
  file.absent:
    - name: '{{ pg.macos.tmpdir }}'
    - onchanges:
      - macpackage: pg-package-install

