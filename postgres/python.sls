{% from "postgres/map.jinja" import postgres with context %}

postgresql-python:
  pkg:
    - installed
    - name: {{ postgresql.python}}
