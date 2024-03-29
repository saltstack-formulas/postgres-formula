# Port to use for the cluster -- can be used to provide a non-standard port
# NOTE: If already set in the minion config, that value takes priority

{%- if grains.os_family not in ['Debian', 'Suse'] %}
postgres.port: '5432'
{%- else %}
postgres.port: '5433'
{%- endif %}

postgres:
  use_upstream_repo: false

  # ### MACOS
  # # Set to 'postgresapp' OR 'homebrew' for MacOS
  # # use_upstream_repo: 'postgresapp'
  # # use_upstream_repo: 'homebrew'

  # # PACKAGE
  # # These pillars are typically never required.
  # # pkg: 'postgresql'
  # # pkg_client: 'postgresql-client'
  # # service: postgresql
  # pkgs_extra:
  #   - postgresql-contrib
  #   - postgresql-plpython

  # CLUSTER
  # The default `encoding` is derived from the `locale` so not recommended
  # to provide a value for it unless necessary
  cluster:
    locale: en_US.UTF-8
    # encoding: UTF8

  # #'Alternatives system' priority incremental. 0 disables feature.
  # linux:
  #   altpriority: 30
  #
  # # macos limits
  # limits:
  #   soft: 64000
  #   hard: 128000

  # POSTGRES
  # Append the lines under this item to your postgresql.conf file.
  # Pay attention to indent exactly with 4 spaces for all lines.
  postgresconf: |-
    listen_addresses = '*'  # listen on all interfaces

  # Path to the `pg_hba.conf` file Jinja template on Salt Fileserver
  pg_hba.conf: salt://postgres/templates/pg_hba.conf.j2

  # This section covers ACL management in the ``pg_hba.conf`` file.
  # acls list controls: which hosts are allowed to connect, how clients
  # are authenticated, which PostgreSQL user names they can use, which
  # databases they can access. Records take one of these forms:
  #
  # acls:
  #  - ['local', 'DATABASE',  'USER',  'METHOD']
  #  - ['host', 'DATABASE',  'USER',  'ADDRESS', 'METHOD']
  #  - ['hostssl', 'DATABASE', 'USER', 'ADDRESS', 'METHOD']
  #  - ['hostnossl', 'DATABASE', 'USER', 'ADDRESS', 'METHOD']
  #
  # The uppercase items must be replaced by actual values.
  # METHOD could be omitted, 'md5' will be appended by default.
  #
  # If ``acls`` item value is empty ('', [], null), then the contents of
  # ``pg_hba.conf`` file will not be touched at all.
  acls:
    - ['local', 'db0', 'connuser', 'peer map=users_as_appuser']
    - ['local', 'db1', 'localUser']
    - ['host', 'db2', 'remoteUser', '192.168.33.0/24']

  identity_map:
    - ['users_as_appuser', 'jdoe', 'connuser']
    - ['users_as_appuser', 'jsmith', 'connuser']

  # Backup extension for configuration files, defaults to ``.bak``.
  # Set ``False`` to stop creation of backups when config files change.
  {%- if salt['status.time']|default(none) is callable %}
  config_backup: ".backup@{{ salt['status.time']('%y-%m-%d_%H:%M:%S') }}"
  {%- endif %}

  {# {%- if grains['init'] == 'unknown' %} #}
  {#  #}
  {# # If Salt is unable to detect init system running in the scope of state run, #}
  {# # probably we are trying to bake a container/VM image with PostgreSQL. #}
  {# # Use ``bake_image`` setting to control how PostgreSQL will be started: if set #}
  {# # to ``True`` the raw ``pg_ctl`` will be utilized instead of packaged init #}
  {# # script, job or unit run with Salt ``service`` state. #}
  {# bake_image: True #}
  {#  #}
  {# {%- endif %} #}

  # Create/remove users, tablespaces, databases, schema and extensions.
  # Each of these dictionaries contains PostgreSQL entities which
  # mapped to the ``postgres_*`` Salt states with arguments. See the Salt
  # documentation to get all supported argument for a particular state.
  #
  # Format is the following:
  #
  #<users|tablespaces|databases|schemas|extensions>:
  #  NAME:
  #    ensure: <present|absent>  # 'present' is the default
  #    ARGUMENT: VALUE
  #    ...
  #
  # where 'NAME' is the state name, 'ARGUMENT' is the kwarg name, and
  # 'VALUE' is kwarg value.
  #
  # For example, the Pillar:
  #
  # users:
  #   testUser:
  #     password: test
  #
  # will render such state:
  #
  # postgres_user-testUser:
  #   postgres_user.present:
  #     - name: testUser
  #     - password: test
  users:
    localUser:
      ensure: present
      password: '98ruj923h4rf'
      createdb: False
      createroles: False
      inherit: True
      replication: False

    remoteUser:
      ensure: present
      password: '98ruj923h4rf'
      createdb: False
      createroles: False
      inherit: True
      replication: False

    absentUser:
      ensure: absent

  # tablespaces to be created
  tablespaces:
    my_space:
      directory: /srv/my_tablespace
      owner: localUser

  # databases to be created
  databases:
    db1:
      owner: localUser
      template: template0
      lc_ctype: en_US.UTF-8
      lc_collate: en_US.UTF-8
    db2:
      owner: remoteUser
      template: template0
      lc_ctype: en_US.UTF-8
      lc_collate: en_US.UTF-8
      tablespace: my_space
      # set custom schema
      schemas:
        public:
          owner: localUser
      # enable per-db extension
      {#- TODO: Find a way to only disable this for the `default` suite, since it works with the `repo` suite #}
      {%- if grains.os_family == 'Debian' and salt['grains.get']('osfinger') != 'Debian-9' %}
      extensions:
        uuid-ossp:
          schema: 'public'
      {%- endif %}

  # optional schemas to enable on database
  schemas:
    uuid-ossp:
      dbname: db1
      owner: localUser

  # optional extensions to install in schema
  {#- TODO: Find a way to only disable this for the `default` suite, since it works with the `repo` suite #}
  {%- if grains.os_family == 'Debian' and salt['grains.get']('osfinger') != 'Debian-9' %}
  extensions:
    uuid-ossp:
      schema: uuid-ossp
      maintenance_db: db1
    # postgis: {}
  {%- endif %}

  # remove:
  #   data: True
  #   multiple_releases: True
  #   releases: ['9.6', '10',]

# vim: ft=yaml ts=2 sts=2 sw=2 et
