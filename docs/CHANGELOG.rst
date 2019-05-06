
Changelog
=========

`0.37.1 <https://github.com/saltstack-formulas/postgres-formula/compare/v0.37.0...v0.37.1>`_ (2019-05-06)
-------------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **readme:** fix link for Travis badge (\ `850ca6a <https://github.com/saltstack-formulas/postgres-formula/commit/850ca6a>`_\ )

`0.37.0 <https://github.com/saltstack-formulas/postgres-formula/compare/v0.36.0...v0.37.0>`_ (2019-05-06)
-------------------------------------------------------------------------------------------------------------

Code Refactoring
^^^^^^^^^^^^^^^^


* **kitchen:** prefer ``kitchen.yml`` to ``.kitchen.yml`` (\ `8f7cbde <https://github.com/saltstack-formulas/postgres-formula/commit/8f7cbde>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile:** prepare for ``inspec`` testing (\ `157e169 <https://github.com/saltstack-formulas/postgres-formula/commit/157e169>`_\ )
* **kitchen:** use pre-salted images as used in ``template-formula`` (\ `611ec11 <https://github.com/saltstack-formulas/postgres-formula/commit/611ec11>`_\ )
* **kitchen+travis:** use newly available pre-salted images (\ `7b7aadc <https://github.com/saltstack-formulas/postgres-formula/commit/7b7aadc>`_\ )
* **pillar_from_files:** use custom pillar based on ``pillar.example`` (\ `c64d9e4 <https://github.com/saltstack-formulas/postgres-formula/commit/c64d9e4>`_\ )
* **travis:** add ``.travis.yml`` based on ``template-formula`` (\ `6467df7 <https://github.com/saltstack-formulas/postgres-formula/commit/6467df7>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** update ``Testing`` section for ``inspec`` (\ `4cfde8d <https://github.com/saltstack-formulas/postgres-formula/commit/4cfde8d>`_\ )

Features
^^^^^^^^


* implement ``semantic-release`` (\ `7d3aa19 <https://github.com/saltstack-formulas/postgres-formula/commit/7d3aa19>`_\ )

Tests
^^^^^


* **inspec:** add tests for multiple ports and postgres versions (\ `bf6a653 <https://github.com/saltstack-formulas/postgres-formula/commit/bf6a653>`_\ )
* **inspec:** enable ``use_upstream_repo`` for ``debian`` & ``centos-6`` (\ `49fdd33 <https://github.com/saltstack-formulas/postgres-formula/commit/49fdd33>`_\ )
* **inspec:** replace ``serverspec`` with ``inspec`` tests (\ `58ac122 <https://github.com/saltstack-formulas/postgres-formula/commit/58ac122>`_\ )
* **inspec:** use relaxed command output match for the time being (\ `3c53684 <https://github.com/saltstack-formulas/postgres-formula/commit/3c53684>`_\ )
