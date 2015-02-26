# Bruse

Multi-purpose personal file database.

## Setup

### Environment variables

To handle environment variables during development, we use the gem
[Figaro](https://github.com/laserlemon/figaro/). This uses looks for variables
set in the file `config/application.yml`. Since we don't want to share our
secrets with the whole internets, this file is ignored by git. Instead, we have
[`config/application.example.yml`](config/application.example.yml).

So, before running the app you **have to rename** this file and remove the
`.example` from the name and **fill the details** listed there.

### API keys and such

Read [Environment variables](#environment-variables) to understand how
environment variables should be stored during development.

#### Dropbox

To use the Dropbox features, you need a key and a secret from Dropbox. You can
get this by creating an app on the
[Dropbox App Console](https://www.dropbox.com/developers/apps). Your app should
be a *Dropbox API app* and have access to everything, basically. Once you've
created your app, add its credentials to your `config/application.yml` file.

### PostgreSQL setup

The following are `psql` commands:

1. Create database user, as seen in [`database.yml`](config/database.yml), we're
gonna use `bruse` as username. Therefore, run `CREATE USER bruse;`.
2. Alter the user password by running `ALTER USER bruse WITH PASSWORD 'kex2015';`.
3. Create development database by running `CREATE DATABASE bruse_development;`
and create test database by running `CREATE DATABASE bruse_test;`.
4. Change database ownership by running `ALTER DATABASE bruse_development OWNER TO bruse;`
and `ALTER DATABASE bruse_test OWNER TO bruse;`.
5. All done!
