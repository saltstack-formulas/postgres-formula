{%- from "postgres/map.jinja" import postgres with context -%}

# This state is used to launch PostgreSQL with ``pg_ctl`` command and enable it
# on "boot" during an image (Docker, Virtual Appliance, AMI) preparation

{%- if postgres.bake_image %}

include:
  - postgres.server

# An attempt to start PostgreSQL with `pg_ctl`

postgresql-start:
  cmd.run:
    - name: pg_ctl -D {{ postgres.conf_dir }} -l logfile start
    - runas: {{ postgres.user }}
    - unless:
      - ps -p $(head -n 1 {{ postgres.conf_dir }}/postmaster.pid) 2>/dev/null
    - require:
      - file: postgresql-pg_hba

# Try to enable PostgreSQL in "manual" way

postgresql-enable:
  cmd.run:
  {%- if salt['file.file_exists']('/bin/systemctl') %}
    - name: systemctl enable {{ postgres.service }}
  {%- elif salt['cmd.which']('chkconfig') %}
    - name: chkconfig {{ postgres.service }} on
  {%- elif salt['file.file_exists']('/usr/sbin/update-rc.d') %}
    - name: update-rc.d {{ service }} defaults
  {%- else %}
    # Nothing to do
    - name: 'true'
  {%- endif %}
    - require:
      - cmd: postgresql-start

{%- else %}

postgresql-start:
  test.show_notification:
    - text: The 'postgres:bake_image' Pillar is disabled (set to 'False').

{%- endif %}
