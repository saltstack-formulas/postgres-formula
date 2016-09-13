{%- from "postgres/map.jinja" import postgres with context %}

{%- if grains['os_family'] == 'Debian' -%}

install-postgresql-repo:
  pkgrepo.managed:
    - humanname: {{ postgres.pkg_repo_humanname }}
    - name: {{ postgres.pkg_repo }}
    - keyid: B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - file: {{ postgres.pkg_repo_file }}
    - require_in:
      - pkg: postgresql-installed

{%- elif grains['os_family'] == 'RedHat' -%}

install-postgresql-repo:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - source: https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG
    - source_hash: md5=78b5db170d33f80ad5a47863a7476b22
  pkgrepo.managed:
    - name: {{ postgres.pkg_repo }}
    - humanname: {{ postgres.pkg_repo_humanname }}
    - baseurl: {{ postgres.pkg_repo_url }}
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - require:
      - file: install-postgresql-repo
    - require_in:
      - pkg: postgresql-installed

{%- endif %}
