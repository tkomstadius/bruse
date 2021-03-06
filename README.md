# Bruse

[![Code Climate](https://codeclimate.com/repos/54ef681a6956806ad40003cc/badges/3ced46e71c97f5a488c1/gpa.svg)](https://codeclimate.com/repos/54ef681a6956806ad40003cc/feed)
[![Test Coverage](https://codeclimate.com/repos/54ef681a6956806ad40003cc/badges/3ced46e71c97f5a488c1/coverage.svg)](https://codeclimate.com/repos/54ef681a6956806ad40003cc/feed)
[![Build Status](https://travis-ci.org/tkomstadius/bruse.svg?branch=develop)](https://travis-ci.org/tkomstadius/bruse)

Multi-purpose personal file database. The application is dependent on some background jobs, i.e. an extra process is needed. So in a new terminal window run `rake jobs:work` to start that process. Also there is a _Procfile_ which tells a process manager like Foreman to run both processes on the command `foreman start` if you don't want to have two different windows open.

## Setup

### Environment variables

To handle environment variables during development, we use the gem
[Figaro](https://github.com/laserlemon/figaro/). This uses looks for variables
set in the file `config/application.yml`. Since we don't want to share our
secrets with the whole internetz, this file is ignored by git. Instead, we have
[`config/application.example.yml`](config/application.example.yml).

So, before running the app you **have to copy** this file and remove the
`.example` from the name and **fill the details** listed there.

#### API keys and such

Read [Environment variables](#environment-variables) to understand how
environment variables should be stored during development.

##### Dropbox

To use the Dropbox features, you need a key and a secret from Dropbox. You can
get this by creating an app on the
[Dropbox App Console](https://www.dropbox.com/developers/apps). Your app should
be a *Dropbox API app* and have access to everything, basically. Once you've
created your app, add its credentials to your `config/application.yml` file.

You also need to add `http://localhost:3000/users/auth/dropbox_oauth2/callback` to your
redirect URLs in your Dropbox app.

##### Google

To use the Google features, you need a key and a secret from Google. You can
get this by creating a project on the [Google developer pages](https://console.developers.google.com/project). Expand the **APIs & auth** heading and select *APIs*. The following APIs should be enabled: *Contacts API*, *Drive API*, *DriveSDK* and *Google+ API*.

Click on the *Consent screen* in the menu. Fill in `Bruse` as *Product name*.

Now select the *Credentials* heading. Click on *Create newClient ID*. The application type should be a *Web application*. In *Authorized JavaScript origins* enter `http://localhost:3000` and at *Authorized redirect URIs* enter `http://localhost:3000/users/auth/google_oauth2/callback`. Once created add its credentials to your `config/application.yml` file. E.g. the *CLIENT ID* and *CLIENT SECRET*.

Now you are finished. The changes can take 10 minutes.

### PostgreSQL setup

The following are `psql` commands:

1. Create database user, as seen in [`database.yml`](config/database.yml), we're
gonna use `bruse` as username. Therefore, run `CREATE USER bruse;`.
2. Alter the user password by running `ALTER USER bruse WITH PASSWORD 'kex2015';`.
3. Alter user to be a superuser, this is for allowing the user to delete and
  create the test database `ALTER USER bruse SUPERUSER;`.
4. Create development database by running `CREATE DATABASE bruse_development;`
and create test database by running `CREATE DATABASE bruse_test;`.
5. Change database ownership by running `ALTER DATABASE bruse_development OWNER TO bruse;`
and `ALTER DATABASE bruse_test OWNER TO bruse;`.
6. All done!

## Testing

To test the javascript in the application run
`rake jasmine:ci JASMINE_CONFIG_PATH=test/javascripts/support/jasmine.yml`. This
will install *phantom js* for you and run the tests headless. For all other test
run `rake test`. Or you could visit our repo on
[Travis CI](https://travis-ci.org/tkomstadius/bruse).
