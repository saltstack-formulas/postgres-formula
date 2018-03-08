========
postgres
========

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``postgres``
------------

Installs and configures both PostgreSQL server and client with creation of various DB objects in
the cluster. This state applies to both Linux and MacOS.

``postgres.client``
-------------------

Installs the PostgreSQL client binaries and libraries on Linux.

``postgres.manage``
-------------------

Creates such DB objects as: users, tablespaces, databases, schemas and extensions.
See ``pillar.example`` file for details.

``postgres.python``
-------------------

Installs the PostgreSQL adapter for Python on Linux.

``postgres.server``
-------------------

Installs the PostgreSQL server package on Linux, prepares the DB cluster and starts the server using
packaged init script, job or unit.

``postgres.server.image``
-------------------------

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
---------------------

Configures the PostgreSQL Official (upstream) repository on target system if
applicable.

The state relies on the ``postgres:use_upstream_repo`` Pillar value which could be set as following:

* ``True`` (default): adds the upstream repository to install packages from
* ``False``: makes sure that the repository configuration is absent
* ``'postgresapp'`` (MacOS) uses upstream PostgresApp package repository.
* ``'homebrew'`` (MacOS) uses Homebrew postgres

The ``postgres:version`` Pillar controls which version of the PostgreSQL packages should be
installed from the upstream Linux repository. Defaults to ``9.5``.

Testing
=======
The postgres state was tested on MacOS (El Capitan 10.11.6)

Testing is done with the ``kitchen-salt``.

``kitchen converge``
--------------------

Runs the ``postgres`` main state.

``kitchen verify``
------------------

Runs ``serverspec`` tests on the actual instance.

``kitchen test``
----------------

Builds and runs tests from scratch.

``kitchen login``
-----------------

Gives you ssh to the vagrant machine for manual testing.

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=2 sw=2 et
