{% from "postgres/map.jinja" import postgres with context %}

{% if grains['os_family'] == 'Debian' %}
install-postgresql-repo:
  pkgrepo.managed:
    - humanname: PostgreSQL Official Repository
    - name: {{ postgres.pkg_repo }} {{ postgres.version }}
    - keyid: B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - file: {{ postgres.pkg_repo_file }}
    - require_in:
      - pkg: install-postgresql
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
install-postgresql-repo:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - source: https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG
    - source_hash: md5=78b5db170d33f80ad5a47863a7476b22
  pkgrepo.managed:
    - name: pgdg-{{ postgres.version }}-centos
    - order: 1
    - humanname: PostgreSQL {{ postgres.version }} $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/{{ postgres.version }}/redhat/rhel-$releasever-$basearch
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - require:
      - file: install-postgresql-repo
{% endif %}
