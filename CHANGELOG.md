# Changelog

## [0.40.4](https://github.com/saltstack-formulas/postgres-formula/compare/v0.40.3...v0.40.4) (2019-10-11)


### Bug Fixes

* **rubocop:** add fixes using `rubocop --safe-auto-correct` ([](https://github.com/saltstack-formulas/postgres-formula/commit/37b0c43))
* **rubocop:** fix remaining errors manually ([](https://github.com/saltstack-formulas/postgres-formula/commit/b369aa9))


### Continuous Integration

* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/postgres-formula/commit/7822200))
* **travis:** merge `rubocop` linter into main `lint` job ([](https://github.com/saltstack-formulas/postgres-formula/commit/2c82872))

## [0.40.3](https://github.com/saltstack-formulas/postgres-formula/compare/v0.40.2...v0.40.3) (2019-10-10)


### Bug Fixes

* **manage.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/postgres-formula/commit/bf5b4d6))
* **python.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/postgres-formula/commit/1f3cfcc))


### Continuous Integration

* **kitchen:** change `log_level` to `debug` instead of `info` ([](https://github.com/saltstack-formulas/postgres-formula/commit/7ca61f3))
* **kitchen:** install required packages to bootstrapped `opensuse` [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/76e3e39))
* **kitchen:** use bootstrapped `opensuse` images until `2019.2.2` [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/3a27978))
* **platform:** add `arch-base-latest` (commented out for now) [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/89e4a34))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/postgres-formula/commit/a0fdd48))

## [0.40.2](https://github.com/saltstack-formulas/postgres-formula/compare/v0.40.1...v0.40.2) (2019-09-13)


### Bug Fixes

* **freebsd:** no libpqdev freebsd package ([eca6d97](https://github.com/saltstack-formulas/postgres-formula/commit/eca6d97))


### Continuous Integration

* **yamllint:** add rule `empty-values` & use new `yaml-files` setting ([9796319](https://github.com/saltstack-formulas/postgres-formula/commit/9796319))

## [0.40.1](https://github.com/saltstack-formulas/postgres-formula/compare/v0.40.0...v0.40.1) (2019-09-11)


### Continuous Integration

* use `dist: bionic` & apply `opensuse-leap-15` SCP error workaround ([fc6cbe0](https://github.com/saltstack-formulas/postgres-formula/commit/fc6cbe0))


### Documentation

* **pillar.example:** update examples for freebsd ([a799214](https://github.com/saltstack-formulas/postgres-formula/commit/a799214))

# [0.40.0](https://github.com/saltstack-formulas/postgres-formula/compare/v0.39.1...v0.40.0) (2019-09-03)


### Features

* **archlinux:** add support, fixing rendering errors ([e970925](https://github.com/saltstack-formulas/postgres-formula/commit/e970925))

## [0.39.1](https://github.com/saltstack-formulas/postgres-formula/compare/v0.39.0...v0.39.1) (2019-09-01)


### Continuous Integration

* **kitchen+travis:** replace EOL pre-salted images ([140928b](https://github.com/saltstack-formulas/postgres-formula/commit/140928b))


### Tests

* **inspec:** fix reference to `suse` after gem `train` update ([677adba](https://github.com/saltstack-formulas/postgres-formula/commit/677adba))

# [0.39.0](https://github.com/saltstack-formulas/postgres-formula/compare/v0.38.0...v0.39.0) (2019-08-17)


### Features

* **yamllint:** include for this repo and apply rules throughout ([1f0fd92](https://github.com/saltstack-formulas/postgres-formula/commit/1f0fd92))

# [0.38.0](https://github.com/saltstack-formulas/postgres-formula/compare/v0.37.4...v0.38.0) (2019-07-24)


### Continuous Integration

* **kitchen:** remove `python*-pip` installation ([d999597](https://github.com/saltstack-formulas/postgres-formula/commit/d999597))
* **kitchen+travis:** modify matrix to include `develop` platform ([3f81439](https://github.com/saltstack-formulas/postgres-formula/commit/3f81439))


### Features

* **debian:** add buster support ([904ba27](https://github.com/saltstack-formulas/postgres-formula/commit/904ba27))

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
