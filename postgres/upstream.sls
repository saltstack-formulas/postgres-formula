{% from "postgres/map.jinja" import postgres with context %}

{% if grains['os'] == 'Ubuntu' %} # Other distro support should be added here
install-postgresql-repo:
  pkgrepo.managed:
    - humanname: PostgreSQL Official Repository
    - name: {{ postgres.pkg_repo }}
    - keyid: B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - file: {{ postgres.pkg_repo_file }}
{% endif %}
