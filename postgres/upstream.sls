{%- from "postgres/map.jinja" import postgres with context -%}
{%- from "postgres/macros.jinja" import format_kwargs with context -%}

{%- if 'pkg_repo' in postgres -%}

  {%- if postgres.use_upstream_repo -%}

# Add upstream repository for your distro
postgresql-repo:
  pkgrepo.managed:
    {{- format_kwargs(postgres.pkg_repo) }}

  {%- else -%}

# Remove the repo configuration (and GnuPG key) as requested
postgresql-repo:
  pkgrepo.absent:
    - name: {{ postgres.pkg_repo.name }}
    {%- if 'pkg_repo_keyid' in postgres %}
    - keyid: {{ postgres.pkg_repo_keyid }}
    {%- endif %}

  {%- endif -%}

{%- else -%}

# Notify that we don't manage this distro
postgresql-repo:
  test.show_notification:
    - text: |
        PostgreSQL does not provide package repository for {{ grains['osfinger'] }}

{%- endif %}
