# Changelog

## [0.37.4](https://github.com/saltstack-formulas/postgres-formula/compare/v0.37.3...v0.37.4) (2019-05-31)


### Continuous Integration

* **travis:** reduce matrix down to 6 instances ([2ff919f](https://github.com/saltstack-formulas/postgres-formula/commit/2ff919f))


### Tests

* **`services_spec`:** remove temporary `suse` conditional ([81165fc](https://github.com/saltstack-formulas/postgres-formula/commit/81165fc))
* **command_spec:** use cleaner `match` string using `%r` ([a054cea](https://github.com/saltstack-formulas/postgres-formula/commit/a054cea))
* **locale:** improve test using locale `en_US.UTF-8` ([7796064](https://github.com/saltstack-formulas/postgres-formula/commit/7796064))

## [0.37.3](https://github.com/saltstack-formulas/postgres-formula/compare/v0.37.2...v0.37.3) (2019-05-16)


### Bug Fixes

* **freebsd-user:** fix FreeBSD daemon's user for PostgreSQL >= 9.6 ([8745365](https://github.com/saltstack-formulas/postgres-formula/commit/8745365)), closes [#263](https://github.com/saltstack-formulas/postgres-formula/issues/263)

## [0.37.2](https://github.com/saltstack-formulas/postgres-formula/compare/v0.37.1...v0.37.2) (2019-05-12)


### Bug Fixes

* **sysrc-svc:** workaround *BSD minion indefinitely hanging on start ([0aa8b4a](https://github.com/saltstack-formulas/postgres-formula/commit/0aa8b4a))

## [0.37.1](https://github.com/saltstack-formulas/postgres-formula/compare/v0.37.0...v0.37.1) (2019-05-06)


### Documentation

* **readme:** fix link for Travis badge ([850ca6a](https://github.com/saltstack-formulas/postgres-formula/commit/850ca6a))

# [0.37.0](https://github.com/saltstack-formulas/postgres-formula/compare/v0.36.0...v0.37.0) (2019-05-06)


### Code Refactoring

* **kitchen:** prefer `kitchen.yml` to `.kitchen.yml` ([8f7cbde](https://github.com/saltstack-formulas/postgres-formula/commit/8f7cbde))


### Continuous Integration

* **gemfile:** prepare for `inspec` testing ([157e169](https://github.com/saltstack-formulas/postgres-formula/commit/157e169))
* **kitchen:** use pre-salted images as used in `template-formula` ([611ec11](https://github.com/saltstack-formulas/postgres-formula/commit/611ec11))
* **kitchen+travis:** use newly available pre-salted images ([7b7aadc](https://github.com/saltstack-formulas/postgres-formula/commit/7b7aadc))
* **pillar_from_files:** use custom pillar based on `pillar.example` ([c64d9e4](https://github.com/saltstack-formulas/postgres-formula/commit/c64d9e4))
* **travis:** add `.travis.yml` based on `template-formula` ([6467df7](https://github.com/saltstack-formulas/postgres-formula/commit/6467df7))


### Documentation

* **readme:** update `Testing` section for `inspec` ([4cfde8d](https://github.com/saltstack-formulas/postgres-formula/commit/4cfde8d))


### Features

* implement `semantic-release` ([7d3aa19](https://github.com/saltstack-formulas/postgres-formula/commit/7d3aa19))


### Tests

* **inspec:** add tests for multiple ports and postgres versions ([bf6a653](https://github.com/saltstack-formulas/postgres-formula/commit/bf6a653))
* **inspec:** enable `use_upstream_repo` for `debian` & `centos-6` ([49fdd33](https://github.com/saltstack-formulas/postgres-formula/commit/49fdd33))
* **inspec:** replace `serverspec` with `inspec` tests ([58ac122](https://github.com/saltstack-formulas/postgres-formula/commit/58ac122))
* **inspec:** use relaxed command output match for the time being ([3c53684](https://github.com/saltstack-formulas/postgres-formula/commit/3c53684))
