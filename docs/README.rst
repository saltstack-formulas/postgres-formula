.. _readme:

postgres-formula
================

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/postgres-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/postgres-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

A formula to install and configure PostgreSQL server.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see :ref:`How to contribute <CONTRIBUTING>` for more details.

Available states
----------------

.. contents::
   :local:

``postgres``
^^^^^^^^^^^^

Installs and configures both PostgreSQL server and client with creation of various DB objects in
the cluster. This state applies to both Linux and MacOS.

``postgres.client``
^^^^^^^^^^^^^^^^^^^

Installs the PostgreSQL client binaries and libraries on Linux.

``postgres.manage``
^^^^^^^^^^^^^^^^^^^

Creates such DB objects as: users, tablespaces, databases, schemas and extensions.
See ``pillar.example`` file for details.

``postgres.python``
^^^^^^^^^^^^^^^^^^^^^^

Installs the PostgreSQL adapter for Python on Linux.

``postgres.server``
^^^^^^^^^^^^^^^^^^^

Installs the PostgreSQL server package on Linux, prepares the DB cluster and starts the server using
packaged init script, job or unit.


.. note::

    For PostgreSQL server before version 10 to work inside a **FreeBSD Jail**
    set ``sysvshm=new`` and ``sysvsem=new``.
    DO NOT SET ``allow.sysvipc=1``. It defeats the purpose of using Jails.

    Further information: https://blog.tyk.nu/blog/freebsd-jails-and-sysv-ipc/


``postgres.server.image``
^^^^^^^^^^^^^^^^^^^^^^^^^

Installs the PostgreSQL server package on Linux, prepares the DB cluster and starts the server by issuing
raw ``pg_ctl`` command. The ``postgres:bake_image`` Pillar toggles this behaviour. For example:

.. code:: yaml

  postgres:
    bake_image: True

If set ``True``, then it becomes possible to fully provision PostgreSQL with all supported entities
from ``postgres.manage`` state during the build ("baking") of AMI / VM / Container images (using
Packer, Docker or similar tools), i.e. when OS ``init`` process is not available to start the
service and enable it on "boot" of resulting appliance.

Also it allows to make Docker images with PostgreSQL using functionality being available since Salt
2016.11.0 release:

.. code:: console

  salt 'minion.with.docker' dockerng.sls_build my-postgres base=centos/systemd mods=postgres

If a lookup dictionary or Pillar has ``postgres:bake_image`` set ``False`` (this is default), it is
equivalent of applying ``postgres.server`` state.

``postgres.upstream``
^^^^^^^^^^^^^^^^^^^^^

Configures the PostgreSQL Official (upstream) repository on target system if
applicable.

The state relies on the ``postgres:use_upstream_repo`` Pillar value which could be set as following:

* ``True`` (default): adds the upstream repository to install packages from
* ``False``: makes sure that the repository configuration is absent
* ``'postgresapp'`` (MacOS) uses upstream PostgresApp package repository.
* ``'homebrew'`` (MacOS) uses Homebrew postgres

The ``postgres:version`` Pillar controls which version of the PostgreSQL packages should be
installed from the upstream Linux repository. Defaults to ``9.5``.


Removal states
--------------

``postgres.dropped``
^^^^^^^^^^^^^^^^^^^^

Meta state to remove Postgres software. By default the release installed by formula is targeted only. To target multiple releases, set pillar ``postgres.remove.multiple_releases: True``.

``postgres.server.remove``
^^^^^^^^^^^^^^^^^^^^^^^^

Remove server, lib, and contrib packages. The ``postgres.server.remove`` will retain data by default (no data loss) - set pillar ``postgres.remove.data: True`` to remove data and configuration directories also.

``postgres.client.remove``
^^^^^^^^^^^^^^^^^^^^^^^^

Remove client package.

``postgres.dev.remove``
^^^^^^^^^^^^^^^^^^^^^^

Remove development and python packages.


Testing
-------

Linux testing is done with ``kitchen-salt``.

``kitchen converge``
^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``postgres`` main state, ready for testing.

``kitchen verify``
^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``kitchen destroy``
^^^^^^^^^^^^^^^^

Removes the docker instance.

``kitchen test``
^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``kitchen login``
^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=2 sw=2 et
