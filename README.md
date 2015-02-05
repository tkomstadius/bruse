# Bruse

Multi-purpose personal file database.

## Setup

### PostgreSQL setup

The following are `psql` commands:

1. Create database user, as seen in [`database.yml`](config/database.yml), we're gonna use `bruse` as username. Therefore, run `CREATE USER bruse;`.
2. Alter the user password by running `ALTER USER bruse WITH PASSWORD 'password';`.
3. Create development database by running `CREATE DATABASE bruse_development;` and create test database by running `CREATE DATABASE bruse_test;`.
4. Change database ownership by running `ALTER DATABASE bruse_development OWNER TO bruse;` and `ALTER DATABASE bruse_test OWNER TO bruse;`.
5. All done!
