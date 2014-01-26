{% from "postgres/map.jinja" import postgres with context %}

postgresql:
  pkg:
    - installed
    - name: {{ postgres.pkg }}

