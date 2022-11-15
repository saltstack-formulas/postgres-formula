{%- from tpldir + "/map.jinja" import postgres with context -%}
{%- from tpldir + "/macros.jinja" import format_kwargs with context -%}

{%- if 'pkg_repo' in postgres -%}
{% set pg_common_version = salt['pkg.version']('postgresql-common') %}

  {%- if postgres.use_upstream_repo == true -%}

    {%- if postgres.add_profile -%}
postgresql-profile:
  file.managed:
    - name: /etc/profile.d/postgres.sh
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://postgres/templates/postgres.sh.j2
    - defaults:
        bin_dir: {{ postgres.bin_dir }}
    {%- endif %}

postgresql-pkg-deps:
  pkg.installed:
    - pkgs: {{ postgres.pkgs_deps | json }}

# Add upstream repository for your distro
  {% if grains.os_family == 'Debian' %}
  {% if salt['pkg.version_cmp'](pg_common_version, '246') <= 0 %}
postgresql-repo-keyring:
  pkg.installed:
    - sources:
      - pgdg-keyring: {{ postgres.pkg_repo_keyring }}
    - require_in:
      - pkgrepo: postgresql-repo
  {%- endif %}
  {%- endif %}

postgresql-repo:
  pkgrepo.managed:
    {{- format_kwargs(postgres.pkg_repo) }}
    - require:
      - pkg: postgresql-pkg-deps

  {%- else -%}

# Remove the repo configuration (and GnuPG key) as requested
postgresql-repo:
  pkgrepo.absent:
    - name: {{ postgres.pkg_repo.name }}
    {%- if 'pkg_repo_keyid' in postgres %}
    - keyid: {{ postgres.pkg_repo_keyid }}
    {%- endif %}

    {% if grains.os_family == 'Debian' %}
postgresql-repo-keyring:
  pkg.removed:
    - name: pgdg-keyring
    {%- endif -%}

  {%- endif -%}

{%- elif grains.os not in ('Windows', 'MacOS',) %}

postgresql-repo:
  test.show_notification:
    - text: |
        PostgreSQL does not provide package repository for {{ salt['grains.get']('osfinger', grains.os) }}

{%- endif %}
