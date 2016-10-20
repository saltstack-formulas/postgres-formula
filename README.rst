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

Installs and configures both PostgreSQL server and client with creation of
various DB objects in the cluster.

``postgres.client``
-------------------

Installs the PostgreSQL client binaries and libraries.

``postgres.manage``
-------------------

Creates such DB objects as: users, tablespaces, databases, schemas and
extensions. See ``pillar.example`` file for details.

``postgres.python``
-------------------

Installs the PostgreSQL adapter for Python.

``postgres.server``
-------------------

Installs the PostgreSQL server package and prepares the DB cluster.

``postgres.upstream``
---------------------

Configures the PostgreSQL Official (upstream) repository on target system if
applicable.

The state relies on the ``postgres:use_upstream_repo`` Pillar value which could
be set as following:

* ``True`` (default): adds the upstream repository to install packages from
* ``False``: makes sure that the repository configuration is absent

The ``postgres:version`` Pillar controls which version of the PostgreSQL
packages should be installed from the upstream repository. Defaults to ``9.5``.

Testing
=======

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
