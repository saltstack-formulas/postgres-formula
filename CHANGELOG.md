# Changelog

## [0.41.8](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.7...v0.41.8) (2021-05-25)


### Bug Fixes

* **jinja:** use json filter ([eb63ec8](https://github.com/saltstack-formulas/postgres-formula/commit/eb63ec85e0f2d15f929ffbf1d483211b7bf4e595))


### Continuous Integration

* add `arch-master` to matrix and update `.travis.yml` [skip ci] ([79feefa](https://github.com/saltstack-formulas/postgres-formula/commit/79feefa7519a5674496b8abfdc68e7baad75f950))
* **kitchen+gitlab:** adjust matrix to add `3003` [skip ci] ([fd8f0e5](https://github.com/saltstack-formulas/postgres-formula/commit/fd8f0e5db5c67f21c16910ab3ed696d59a7eeee2))
* **vagrant:** add FreeBSD 13.0 [skip ci] ([93bb123](https://github.com/saltstack-formulas/postgres-formula/commit/93bb123ea1a8e5037c8898777ba90338979e802f))
* **vagrant:** use pre-salted boxes & conditional local settings [skip ci] ([69812c1](https://github.com/saltstack-formulas/postgres-formula/commit/69812c1f62b90ba9094c873930ac334edac9a0aa))


### Documentation

* **readme:** fix headings [skip ci] ([c97317c](https://github.com/saltstack-formulas/postgres-formula/commit/c97317c39fe46375a78b478c08210d25461548ff))

## [0.41.7](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.6...v0.41.7) (2021-03-26)


### Continuous Integration

* enable Vagrant-based testing using GitHub Actions ([2ebc9c1](https://github.com/saltstack-formulas/postgres-formula/commit/2ebc9c11da512c8bc2089e8ecb28f5d3e13261f1))
* **kitchen+ci:** use latest pre-salted images (after CVE) [skip ci] ([cc43d1c](https://github.com/saltstack-formulas/postgres-formula/commit/cc43d1c90db36c232012bc80b66baa248ece3c42))


### Documentation

* **readme:** add `Testing with Vagrant` section ([ed2d688](https://github.com/saltstack-formulas/postgres-formula/commit/ed2d6884b10725fad55b83de4972e59710f1970f))


### Tests

* standardise use of `share` suite & `_mapdata` state [skip ci] ([fc53d97](https://github.com/saltstack-formulas/postgres-formula/commit/fc53d977b32290834dc5aa17fe461154b269d38c))

## [0.41.6](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.5...v0.41.6) (2021-02-26)


### Bug Fixes

* **repo:** check whether pkg_repo is set ([26b2233](https://github.com/saltstack-formulas/postgres-formula/commit/26b223323fa65abee731af04ee9631062a78b308))
* **repo:** reorder dependencies to prevent errors ([750d8aa](https://github.com/saltstack-formulas/postgres-formula/commit/750d8aab7a7e386e5ca0a3d546bb5cf12aa4506c))


### Continuous Integration

* **gemfile+lock:** use `ssf` customised `kitchen-docker` repo [skip ci] ([476b15e](https://github.com/saltstack-formulas/postgres-formula/commit/476b15e326b72a6bbdb9635d612f30b7a51ce7fa))
* **kitchen+gitlab-ci:** use latest pre-salted images [skip ci] ([6f04b31](https://github.com/saltstack-formulas/postgres-formula/commit/6f04b3191c6d1354d376473ff6e3ba213d614a4d))
* **pre-commit:** update hook for `rubocop` [skip ci] ([e964c26](https://github.com/saltstack-formulas/postgres-formula/commit/e964c26a29e61c5455b880e00195d5a0f55de641))


### Tests

* **command_spec:** fix `rubocop` violation [skip ci] ([73c39af](https://github.com/saltstack-formulas/postgres-formula/commit/73c39aff5ef9bf5808a251f70504e3b019087f01))
* **pillar:** update conditional to include Tumbleweed ([e976ee9](https://github.com/saltstack-formulas/postgres-formula/commit/e976ee9c9924363db400b23cbde914112b6b4349))

## [0.41.5](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.4...v0.41.5) (2021-01-07)


### Bug Fixes

* **cent7:** postgres11 needs libicu installed ([4c0f796](https://github.com/saltstack-formulas/postgres-formula/commit/4c0f796f00901b88e0ee9d778a5acb2115bf17cb))


### Continuous Integration

* **commitlint:** ensure `upstream/master` uses main repo URL [skip ci] ([e84389d](https://github.com/saltstack-formulas/postgres-formula/commit/e84389dbb31f04f3eeabfd3935ef193e09e5b562))
* **gitlab-ci:** add `rubocop` linter (with `allow_failure`) [skip ci] ([2615411](https://github.com/saltstack-formulas/postgres-formula/commit/2615411ec019600328c330cb4e72de89472f8fc9))

## [0.41.4](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.3...v0.41.4) (2020-12-16)


### Bug Fixes

* **archlinux:** avoid nonetype error ([0a6cf8f](https://github.com/saltstack-formulas/postgres-formula/commit/0a6cf8fefae1bbd5668a447ced911088ac965475))
* **archlinux:** use consistent jinja repo check ([3a955e0](https://github.com/saltstack-formulas/postgres-formula/commit/3a955e02708b23929c93f879bcba0e3fe5ae5666))
* **jinja:** syntax correction ([8b44c06](https://github.com/saltstack-formulas/postgres-formula/commit/8b44c068fcfd4199336596bdba095fc0e6c8fb2e))
* **python:** use python3 postres on cent7/8 ([d6d1068](https://github.com/saltstack-formulas/postgres-formula/commit/d6d1068395131de08534e387d377389bd078d3ee))
* **suse:** version 11+ repo support on suse ([b3f381e](https://github.com/saltstack-formulas/postgres-formula/commit/b3f381e54750a00bb19a4aa50c6273c627dca16c))


### Continuous Integration

* **gitlab-ci:** use GitLab CI as Travis CI replacement ([a45673a](https://github.com/saltstack-formulas/postgres-formula/commit/a45673a87892deb973afee3689aea4bebd7a5739))
* **pre-commit:** add to formula [skip ci] ([db1794b](https://github.com/saltstack-formulas/postgres-formula/commit/db1794b6bbb6ce183e5231cb4b7e7193dcb80143))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([f04d60a](https://github.com/saltstack-formulas/postgres-formula/commit/f04d60a773461dce98b4f2a7c8abbbab268513a0))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([7036f60](https://github.com/saltstack-formulas/postgres-formula/commit/7036f60e8ca3857beeca18abe70a3c59b6a021ec))

## [0.41.3](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.2...v0.41.3) (2020-09-29)


### Bug Fixes

* **upstream:** require_in/require use_upstream ([ab6b97e](https://github.com/saltstack-formulas/postgres-formula/commit/ab6b97e8c3ff40f9cb2e629c3c0faf09ca59ede9))

## [0.41.2](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.1...v0.41.2) (2020-07-27)


### Bug Fixes

* **macros:** fix `format_kwargs` macro ([5e6511b](https://github.com/saltstack-formulas/postgres-formula/commit/5e6511b783388930010e6c0795b197728fb10b39))


### Continuous Integration

* **kitchen:** ubuntu-2004-master-py3 added ([7978976](https://github.com/saltstack-formulas/postgres-formula/commit/79789765439bb0727521dc817fe9eaebba000a67))
* **kitchen+travis:** use latest pre-salted images [skip ci] ([702323c](https://github.com/saltstack-formulas/postgres-formula/commit/702323c24df1df6b11defd663b55cf38586bd3f3))
* **travis:** ubuntu upgrade from 16 to 18 & 20 ([44568a6](https://github.com/saltstack-formulas/postgres-formula/commit/44568a680602fb61f157b74dc05f9af9b153e8e6))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([8735cf8](https://github.com/saltstack-formulas/postgres-formula/commit/8735cf8ad1b9fc1eb816aecf3d363d4fc81fbe66))

## [0.41.1](https://github.com/saltstack-formulas/postgres-formula/compare/v0.41.0...v0.41.1) (2020-07-10)


### Bug Fixes

* **contributing:** postgresql-repo state ID requires python3-apt package ([69b57e3](https://github.com/saltstack-formulas/postgres-formula/commit/69b57e3b69062d0b66bd9fb28e3769a9ff579faa))
* **contributing:** postgresql-service-reload type ([278893c](https://github.com/saltstack-formulas/postgres-formula/commit/278893c2f0f3fa8db26b45b3874f7dd7177b714a))
* **contributing:** runnig formula inside container ([68a791e](https://github.com/saltstack-formulas/postgres-formula/commit/68a791ef091114b081f71631d94201a9f1ed07b6))
* **libtofs:** “files_switch” mess up the variable exported by “map.jinja” [skip ci] ([e6b1485](https://github.com/saltstack-formulas/postgres-formula/commit/e6b14853d5ce2369ead22cabdfc48ae63f64e550))
* **postgres.server:** reverted how posrgre.server.image is included ([07044bf](https://github.com/saltstack-formulas/postgres-formula/commit/07044bf7c1d420855b43d6add30358ff39666702))


### Continuous Integration

* **gemfile:** remove unused `rspec-retry` gem [skip ci] ([85feac2](https://github.com/saltstack-formulas/postgres-formula/commit/85feac2852ee399f37293b60008e3a17d19cd47f))
* **gemfile:** update for Vagrant testing [skip ci] ([061715e](https://github.com/saltstack-formulas/postgres-formula/commit/061715e560880a9a60720bbcbeda632c010d03a4))
* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([35850da](https://github.com/saltstack-formulas/postgres-formula/commit/35850da22cb4f61144a61098b9869603b6e0a682))
* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([86697d8](https://github.com/saltstack-formulas/postgres-formula/commit/86697d8df48e24e37d6885f68ea8988d43b076aa))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([5e29999](https://github.com/saltstack-formulas/postgres-formula/commit/5e29999495f36653aa1b51f2baf956533fdee7e4))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([c46053a](https://github.com/saltstack-formulas/postgres-formula/commit/c46053abd8019a4229daf19db1af86c5f8961353))
* **travis:** add notifications => zulip [skip ci] ([442cfec](https://github.com/saltstack-formulas/postgres-formula/commit/442cfec245fb6b22d7768c8436ba6c62ca2975fd))
* **workflows/commitlint:** add to repo [skip ci] ([0c766c8](https://github.com/saltstack-formulas/postgres-formula/commit/0c766c8e2e336e31d44fdddf5f4c5e56faa9e40e))


### Documentation

* **container:** "postgres:bake_image" specifics ([904a525](https://github.com/saltstack-formulas/postgres-formula/commit/904a5258cd155f3b5a83ec8dc8e990a8ffc6b798))

# [0.41.0](https://github.com/saltstack-formulas/postgres-formula/compare/v0.40.5...v0.41.0) (2019-12-27)


### Bug Fixes

* **mac_shortcut.sh:** fix `shellcheck` error ([d538798](https://github.com/saltstack-formulas/postgres-formula/commit/d538798ee4423ecb72b29bd39e4f35437412ce43))
* **release.config.js:** use full commit hash in commit link [skip ci] ([f3ec66d](https://github.com/saltstack-formulas/postgres-formula/commit/f3ec66d5ed90bc9a458fdff2233c9a707f0c9c72))


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([a77bb06](https://github.com/saltstack-formulas/postgres-formula/commit/a77bb06b18823c7db0debd2c4ff135a367f76d04))
* **kitchen:** use `develop` image until `master` is ready (`amazonlinux`) [skip ci] ([20e5e46](https://github.com/saltstack-formulas/postgres-formula/commit/20e5e46e1011641714a11756617530b898e3d689))
* **kitchen+travis:** upgrade matrix after `2019.2.2` release [skip ci] ([8080be6](https://github.com/saltstack-formulas/postgres-formula/commit/8080be6be3dd0c8799fa102b1235fb151514bced))
* **travis:** apply changes from build config validation [skip ci] ([8ce1ee4](https://github.com/saltstack-formulas/postgres-formula/commit/8ce1ee4ecc5dd6a6a14118eda75b3446b6f58d82))
* **travis:** opt-in to `dpl v2` to complete build config validation [skip ci] ([bd5959c](https://github.com/saltstack-formulas/postgres-formula/commit/bd5959c60a93e65ea0658f5cb7fd1609bdd3399c))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([0a2b63a](https://github.com/saltstack-formulas/postgres-formula/commit/0a2b63aba85b09c8983d066cbad7e344de791db1))
* **travis:** run `shellcheck` during lint job [skip ci] ([f0d12ca](https://github.com/saltstack-formulas/postgres-formula/commit/f0d12caac67bf7f2049ca7f1b7185912e876cb02))
* **travis:** use `major.minor` for `semantic-release` version [skip ci] ([1392538](https://github.com/saltstack-formulas/postgres-formula/commit/1392538665bea2a699836a87a6b749e07276a94d))
* **travis:** use build config validation (beta) [skip ci] ([c9a57aa](https://github.com/saltstack-formulas/postgres-formula/commit/c9a57aa96bb80dc27c4722e0f8dc45c77460c03a))


### Features

* **codenamemap:** update for current versions ([9cc95c0](https://github.com/saltstack-formulas/postgres-formula/commit/9cc95c020909563486f404b186e15ed71dd8a83a))


### Performance Improvements

* **travis:** improve `salt-lint` invocation [skip ci] ([ccaf4e5](https://github.com/saltstack-formulas/postgres-formula/commit/ccaf4e5e3729c75c3a5eccbf482e7fca09415fea))

## [0.40.5](https://github.com/saltstack-formulas/postgres-formula/compare/v0.40.4...v0.40.5) (2019-10-28)


### Bug Fixes

* **macros.jinja:** apply suggestion from PR ([](https://github.com/saltstack-formulas/postgres-formula/commit/d606b28))
* **macros.jinja:** use `user` kwarg for schemas (required on FreeBSD) ([](https://github.com/saltstack-formulas/postgres-formula/commit/7ff798a))


### Continuous Integration

* **kitchen:** add pre-salted `FreeBSD-12.0` box for local testing ([](https://github.com/saltstack-formulas/postgres-formula/commit/eefb89e))
* **kitchen:** use `debian-10-master-py3` instead of `develop` [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/81b2c2e))
* **travis:** update `salt-lint` config for `v0.0.10` [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/62baac2))


### Documentation

* **contributing:** remove to use org-level file instead [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/5a291ab))
* **readme:** update link to `CONTRIBUTING` [skip ci] ([](https://github.com/saltstack-formulas/postgres-formula/commit/e568f28))

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
