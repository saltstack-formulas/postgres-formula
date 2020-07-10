{%- from tpldir + "/map.jinja" import postgres with context -%}
{%- from tpldir + "/macros.jinja" import format_kwargs with context -%}

{%- if 'pkg_repo' in postgres -%}

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
    - pkgs: {{ postgres.pkgs_deps }}

# Add upstream repository for your distro
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

  {%- endif -%}

{%- elif grains.os not in ('Windows', 'MacOS',) %}

postgresql-repo:
  test.show_notification:
    - text: |
        PostgreSQL does not provide package repository for {{ salt['grains.get']('osfinger', grains.os) }}

{%- endif %}
