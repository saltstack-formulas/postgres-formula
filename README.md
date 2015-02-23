# postgres

It sets up [PostgreSQL](http://www.postgresql.org/).

For the best practises see [salt formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)

## Available states


#### ``postgres``

Installs the postgresql package.

#### ``postgres.python``

Installs the postgresql python module

## Testing

Testing is done wit kitchen-salt

#### ``kitchen converge``

Runs the postgres main state

#### ``kitchen verify``

Runs serverspec tests on the actual instance

#### ``kitchen test``

Builds and runs test from scratch

#### ``kitchen login``

Gives you ssh to the vagrant machine for manual testing

