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

Installs the PostgreSQL server package and prepares the DB cluster.

``postgres.client``
-------------------

Installs the PostgreSQL client binaries and libraries.

``postgres.python``
-------------------

Installs the PostgreSQL adapter for Python.

``postgres.upstream``
---------------------

Configures the PostgreSQL Official (upstream) repository on target system if
applicable.

The state relies on the ``postgres:use_upstream_repo`` Pillar value which could
be set as following:

* ``False`` (default): makes sure that the repository configuration is absent
* ``True``: adds the upstream repository to install packages from

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
