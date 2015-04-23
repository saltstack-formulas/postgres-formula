'''
Management of PostgreSQL tablespace
==================================
The postgres_tablespace module is used to create and manage Postgres
tablespaces.
Tablespaces can be set as either absent or present.
.. code-block:: yaml
    ssd-tablespace:
      postgres_tablespace.present:
        - name: indexes
        - path:
'''
from __future__ import absolute_import


def __virtual__():
    '''
    Only load if the postgres_ext module is present
    '''
    return 'postgres_ext.tablespace_exists' in __salt__

def present(name,
            directory,
            options=None,
            owner=None,
            user=None,
            maintenance_db=None,
            db_password=None,
            db_host=None,
            db_port=None,
            db_user=None):
    '''
    Ensure that the named tablespace is present with the specified properties.
    For more information about all of these options see man create_tablespace(1)
    name
        The name of the tablespace to manage
    directory
        The directory where the tablespace will be located
    db_user
        database username if different from config or defaul
    db_password
        user password if any password for a specified user
    db_host
        Database host if different from config or default
    db_port
        Database port if different from config or default
    user
        System user all operations should be performed on behalf of
        .. versionadded:: Beryllium
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'Tablespace {0} is already present'.format(name)}
    dbargs = {
        'maintenance_db': maintenance_db,
        'runas': user,
        'host': db_host,
        'user': db_user,
        'port': db_port,
        'password': db_password,
    }
    tblspaces = __salt__['postgres_ext.tablespace_list'](**dbargs)
    if name not in tblspaces:
        # not there, create it
        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = 'Tablespace {0} is set to be created'.format(name)
            return ret
        if __salt__['postgres_ext.tablespace_create'](name, directory, **dbargs):
            ret['comment'] = 'The tablespace {0} has been created'.format(name)
            ret['changes'][name] = 'Present'
        return ret

    # already exists, make sure it's got the right path
    if tblspaces[name]['Location'] != directory:
        ret['comment'] = 'Tablespace {0} isn\'t at the right path'.format(
            name)
        ret['result'] = False
        return ret # This isn't changeable, they need to remove/remake

    if (owner and not tblspaces[name]['Owner'] == owner):
        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = 'Tablespace {0} owner to be altered'.format(name)
            return ret
        if __salt__['postgres_ext.tablespace_alter'](name, new_owner=owner):
            ret['comment'] = 'Tablespace {0} owner changed'.format(name)
            ret['result'] = True

    return ret


def absent(name,
           user=None,
           maintenance_db=None,
           db_password=None,
           db_host=None,
           db_port=None,
           db_user=None):
    '''
    Ensure that the named database is absent
    name
        The name of the database to remove
    db_user
        database username if different from config or defaul
    db_password
        user password if any password for a specified user
    db_host
        Database host if different from config or default
    db_port
        Database port if different from config or default
    user
        System user all operations should be performed on behalf of
        .. versionadded:: Beryllium
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    db_args = {
        'maintenance_db': maintenance_db,
        'runas': user,
        'host': db_host,
        'user': db_user,
        'port': db_port,
        'password': db_password,
    }
    #check if tablespace exists and remove it
    if __salt__['postgres_ext.tablespace_exists'](name, **db_args):
        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = 'Tablespace {0} is set to be removed'.format(name)
            return ret
        if __salt__['postgres_ext.tablespace_remove'](name, **db_args):
            ret['comment'] = 'Tablespace {0} has been removed'.format(name)
            ret['changes'][name] = 'Absent'
            return ret

    # fallback
    ret['comment'] = 'Tablespace {0} is not present, so it cannot ' \
                     'be removed'.format(name)
    return ret
