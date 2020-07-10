{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import postgres with context -%}

# This state is used to launch PostgreSQL with ``pg_ctl`` command and enable it
# on "boot" during an image (Docker, Virtual Appliance, AMI) preparation

{%- if postgres.bake_image %}

# An attempt to start PostgreSQL with `pg_ctl`
postgresql-running:
  cmd.run:
    - name: {{ postgres.bake_image_run_cmd }}
    - runas: {{ postgres.user }}
    - unless:
      - ps -p $(head -n 1 {{ postgres.data_dir }}/postmaster.pid) 2>/dev/null
    - require:
      - file: postgresql-pg_hba

postgresql-service-reload:
  module.run:
    - name: test.true
    - require:
      - cmd: postgresql-running

# Try to enable PostgreSQL in "manual" way

postgresql-enable:
  cmd.run:
  {%- if salt['file.file_exists']('/bin/systemctl') %}
    - name: systemctl enable {{ postgres.service.name }}
  {%- elif salt['cmd.which']('chkconfig') %}
    - name: chkconfig {{ postgres.service.name }} on
  {%- elif salt['file.file_exists']('/usr/sbin/update-rc.d') %}
    - name: update-rc.d {{ postgres.service.name }} defaults
  {%- else %}
    # Nothing to do
    - name: 'true'
  {%- endif %}
    - require:
      - cmd: postgresql-running

{%- endif %}
