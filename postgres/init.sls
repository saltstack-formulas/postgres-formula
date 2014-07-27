{% from "postgres/map.jinja" import postgres with context %}

postgresql:
  pkg:
    - installed
    - name: {{ postgres.pkg }}
  service:
    - running
    - enable: true
    - name: {{ postgres.service }}
    - require:
      - pkg: {{ postgres.pkg }}
      
postgresql-server-dev-9.3:
  pkg.installed

{% if 'pg_hba.conf' in pillar.get('postgres', {}) %}
pg_hba.conf:
  file.managed:
    - name: {{ postgres.pg_hba }}
    - source: {{ salt['pillar.get']('postgres:pg_hba.conf', 'salt://postgres/pg_hba.conf') }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: postgresql
{% endif %}

{% if 'db' in pillar.get('postgres', {}) %}
postgres-app-user:
  postgres_user.present:
    - name: {{ salt['pillar.get']('postgres:db:user', 'myuser') }}
    - createdb: {{ salt['pillar.get']('postgres:db:createdb', False) }}
    - password: {{ salt['pillar.get']('postgres:db:password', 'mypass') }}
    - runas: postgres
    - require:
      - service: {{ postgres.service }}

postgres-app-db:
  postgres_database.present:
    - name: {{ salt['pillar.get']('postgres:db:name', 'mydb') }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: {{ salt['pillar.get']('postgres:db:user', 'myuser') }}
    - runas: postgres
    - require:
        - postgres_user: postgres-app-user
{% endif %}
