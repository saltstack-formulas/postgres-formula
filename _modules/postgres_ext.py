from __future__ import absolute_import
import logging
try:
    import pipes
    import csv
    HAS_ALL_IMPORTS = True
except ImportError:
    HAS_ALL_IMPORTS = False

# All this can be removed when we merge this stuff upstream
import salt.utils

log = logging.getLogger(__name__)

def __virtual__():
    '''
    Only load this module if the postgres module is already loaded
    '''
    if all((salt.utils.which('psql'), HAS_ALL_IMPORTS)):
        return True
    return False

# Copied directly from salt/modules/postgres.py, remove when upstreaming
def _run_psql(cmd, runas=None, password=None, host=None, port=None, user=None):
    '''
    Helper function to call psql, because the password requirement
    makes this too much code to be repeated in each function below
    '''
    kwargs = {
        'reset_system_locale': False,
        'clean_env': True,
    }
    if runas is None:
        if not host:
            host = __salt__['config.option']('postgres.host')
        if not host or host.startswith('/'):
            if 'FreeBSD' in __grains__['os_family']:
                runas = 'pgsql'
            if 'OpenBSD' in __grains__['os_family']:
                runas = '_postgresql'
            else:
                runas = 'postgres'

    if user is None:
        user = runas

    if runas:
        kwargs['runas'] = runas

    if password is None:
        password = __salt__['config.option']('postgres.pass')
    if password is not None:
        pgpassfile = salt.utils.mkstemp(text=True)
        with salt.utils.fopen(pgpassfile, 'w') as fp_:
            fp_.write('{0}:{1}:*:{2}:{3}'.format(
                'localhost' if not host or host.startswith('/') else host,
                port if port else '*',
                user if user else '*',
                password,
            ))
            __salt__['file.chown'](pgpassfile, runas, '')
            kwargs['env'] = {'PGPASSFILE': pgpassfile}

    ret = __salt__['cmd.run_all'](cmd, python_shell=False, **kwargs)

    if ret.get('retcode', 0) != 0:
        log.error('Error connecting to Postgresql server')
    if password is not None and not __salt__['file.remove'](pgpassfile):
        log.warning('Remove PGPASSFILE failed')

    return ret


def _connection_defaults(user=None, host=None, port=None, maintenance_db=None,
                         password=None):
    '''
    Returns a tuple of (user, host, port, db) with config, pillar, or default
    values assigned to missing values.
    '''
    if not user:
        user = __salt__['config.option']('postgres.user')
    if not host:
        host = __salt__['config.option']('postgres.host')
    if not port:
        port = __salt__['config.option']('postgres.port')
    if not maintenance_db:
        maintenance_db = __salt__['config.option']('postgres.maintenance_db')
    if password is None:
        password = __salt__['config.option']('postgres.pass')

    return (user, host, port, maintenance_db, password)


def _psql_cmd(*args, **kwargs):
    '''
    Return string with fully composed psql command.
    Accept optional keyword arguments: user, host and port as well as any
    number or positional arguments to be added to the end of command.
    '''
    (user, host, port, maintenance_db, password) = _connection_defaults(
        kwargs.get('user'),
        kwargs.get('host'),
        kwargs.get('port'),
        kwargs.get('maintenance_db'),
        kwargs.get('password'))

    cmd = [salt.utils.which('psql'),
           '--no-align',
           '--no-readline',
           '--no-password']         # It is never acceptable to issue a password prompt.
    if user:
        cmd += ['--username', user]
    if host:
        cmd += ['--host', host]
    if port:
        cmd += ['--port', str(port)]
    if not maintenance_db:
        maintenance_db = 'postgres'
    cmd += ['--dbname', maintenance_db]
    cmd += args
    cmdstr = ' '.join([pipes.quote(c) for c in cmd])
    return cmdstr


def _psql_prepare_and_run(cmd,
                          host=None,
                          port=None,
                          maintenance_db=None,
                          password=None,
                          runas=None,
                          user=None):
    rcmd = _psql_cmd(
        host=host, user=user, port=port,
        maintenance_db=maintenance_db, password=password,
        *cmd)
    cmdret = _run_psql(
        rcmd, runas=runas, password=password, host=host, port=port, user=user)
    return cmdret

def tablespace_list(user=None, host=None, port=None, maintenance_db=None,
                    password=None, runas=None):
    '''
    Return dictionary with information about tablespaces of a Postgres server.
    CLI Example:
    .. code-block:: bash
        salt '*' postgres_ext.tablespace_list
    '''

    ret = {}

    query = (
        'SELECT spcname as "Name", pga.rolname as "Owner", spcacl as "ACL", '
        'spcoptions as "Opts", pg_tablespace_location(pgts.oid) as "Location" '
        'FROM pg_tablespace pgts, pg_roles pga WHERE pga.oid = pgts.spcowner'
    )

    rows = __salt__['postgres.psql_query'](query, runas=runas, host=host,
                                           user=user, port=port,
                                           maintenance_db=maintenance_db,
                                           password=password)

    for row in rows:
        ret[row['Name']] = row
        ret[row['Name']].pop('Name')

    return ret


def tablespace_exists(name, user=None, host=None, port=None, maintenance_db=None,
              password=None, runas=None):
    '''
    Checks if a tablespace exists on the Postgres server.
    CLI Example:
    .. code-block:: bash
        salt '*' postgres_ext.tablespace_exists 'dbname'
    '''

    tablespaces = tablespace_list(user=user, host=host, port=port,
                        maintenance_db=maintenance_db,
                        password=password, runas=runas)
    return name in tablespaces


def tablespace_create(name, location, user=None, host=None, port=None,
              maintenance_db=None, password=None, runas=None):
    '''
    Adds a tablespace to the Postgres server.

    CLI Example:

    .. code-block:: bash

        salt '*' postgres_ext.tablespace_create tablespacename '/path/datadir'
    '''
    query = 'CREATE TABLESPACE {0} LOCATION \'{1}\''.format(name, location)

    # Execute the command
    ret = _psql_prepare_and_run(['-c', query],
                                user=user, host=host, port=port,
                                maintenance_db=maintenance_db,
                                password=password, runas=runas)
    return ret['retcode'] == 0


def tablespace_alter(name, user=None, host=None, port=None, maintenance_db=None,
                     password=None, new_name=None, new_owner=None,
                     set_option=None, reset_option=None, runas=None):
    '''
    Change tablespace name, owner, or options.
    CLI Example:
    .. code-block:: bash
        salt '*' postgres_ext.tablespace_alter tsname new_owner=otheruser
        salt '*' postgres_ext.tablespace_alter index_space new_name=fast_raid
        salt '*' postgres_ext.tablespace_alter tsname reset_option=seq_page_cost
    '''
    if not any([new_name, new_owner, set_option, reset_option]):
        return True  # Nothing todo?

    queries = []

    if new_name:
        queries.append('ALTER TABLESPACE {} RENAME TO {}'.format(
                       name, new_name))
    if new_owner:
        queries.append('ALTER TABLESPACE {} OWNER TO {}'.format(
                       name, new_owner))
    if set_option:
        queries.append('ALTER TABLESPACE {} SET ({} = {})'.format(
                       name, set_option[0], set_option[1]))
    if reset_option:
        queries.append('ALTER TABLESPACE {} RESET ({})'.format(
                       name, reset_option))

    for query in queries:
        ret = _psql_prepare_and_run(['-c', query],
                                    user=user, host=host, port=port,
                                    maintenance_db=maintenance_db,
                                    password=password, runas=runas)
        if ret['retcode'] != 0:
            return False

    return True


def tablespace_remove(name, user=None, host=None, port=None,
                      maintenance_db=None, password=None, runas=None):
    '''
    Removes a tablespace from the Postgres server.
    CLI Example:
    .. code-block:: bash
        salt '*' postgres_ext.tablespace_remove tsname
    '''
    query = 'DROP TABLESPACE {}'.format(name)
    ret = _psql_prepare_and_run(['-c', query],
                                user=user,
                                host=host,
                                port=port,
                                runas=runas,
                                maintenance_db=maintenance_db,
                                password=password)
    return ret['retcode'] == 0
