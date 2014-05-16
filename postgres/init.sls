{% from "postgres/map.jinja" import postgres with context %}

postgresql:
  pkg:
    - installed
    - name: {{ postgres.pkg }}
  service:
    - running
    - enable: true
    - name: {{ postgres.service }}
    - watch:
      - file: {{ postgres.pg_hba }}
    - require:
      - pkg: {{ postgres.pkg }}

pg_hba.conf:
  file.managed:
    - name: {{ postgres.pg_hba }}
    - source: salt://postgres/pg_hba.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
      - pkg: {{ postgres.pkg }}

postgres-app-user:
  postgres_user.present:
    - name: {{ pillar['postgres']['db']['user'] }}
    - createdb: {{ pillar['postgres']['db']['createdb'] }}
    - password: {{ pillar['postgres']['db']['password'] }}
    - runas: postgres
    - require:
      - service: {{ postgres.service }}

postgres-app-db:
  postgres_database.present:
    - name: {{ pillar['postgres']['db']['name'] }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: {{ pillar['postgres']['db']['user'] }}
    - runas: postgres
    - require:
        - postgres_user: postgres-app-user
