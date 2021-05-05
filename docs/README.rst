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

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

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
^^^^^^^^^^^^^^^^^^^

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


**Running inside a container** (using Packer, Docker or similar tools), when OS ``init`` process
is not available to start the service and enable it on "boot", set pillar value:

.. code:: yaml

  postgres:
    bake_image: True

This toggles starting PostgreSQL daemon by issuing raw ``pg_ctl`` or ``pg_ctlcluster`` command.

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
^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove server, lib, and contrib packages. The ``postgres.server.remove`` will retain data by default (no data loss) - set pillar ``postgres.remove.data: True`` to remove data and configuration directories also.

``postgres.client.remove``
^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove client package.

``postgres.dev.remove``
^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``kitchen test``
^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``kitchen login``
^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

Testing with Vagrant
--------------------

Windows/FreeBSD/OpenBSD testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Virtualbox
* Vagrant

Setup
^^^^^

.. code-block:: bash

   $ gem install bundler
   $ bundle install --with=vagrant
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.vagrant.yml``,
e.g. ``windows-81-latest-py3``.

Note
^^^^

When testing using Vagrant you must set the environment variable ``KITCHEN_LOCAL_YAML`` to ``kitchen.vagrant.yml``.  For example:

.. code-block:: bash

   $ KITCHEN_LOCAL_YAML=kitchen.vagrant.yml bin/kitchen test      # Alternatively,
   $ export KITCHEN_LOCAL_YAML=kitchen.vagrant.yml
   $ bin/kitchen test

Then run the following commands as needed.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the Vagrant instance and runs the ``postgres`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the Vagrant instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you RDP/SSH access to the instance for manual testing.

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=2 sw=2 et
