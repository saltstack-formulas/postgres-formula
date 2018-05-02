{% from tpldir + "/map.jinja" import postgres with context %}

postgresql-python:
  pkg.installed:
    - name: {{ postgres.pkg_python}}
  {% if postgres.fromrepo %}
    - fromrepo: {{ postgres.fromrepo }}
  {% endif %}
