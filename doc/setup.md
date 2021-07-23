# Setting Up Development

<sub>↩ Back to [README](/README.md)</sub>

This is a Ruby on Rails 6.0 application with Vue + Webpack included.

To get started developing on your machine, you'll need the following tools installed:

* ruby 2.7+, bundler 2+
* node 14+, yarn 1.16+

This project uses webpacker to bundle front end assets, including:

* [vue](https://vuejs.org/) 2+
* [bulma css](https://bulma.io/) 0.8+
* [buefy](https://buefy.org/) 0.8+

## Setting up services

There are two ways to run services in your development environment:

* Use [Docker](#development-with-docker).
* Install local services on your development host:
    * [PostgreSQL 9.5+](#setting-up-postgresql)
    * [Mailcatcher 0.7.1](#setting-up-mailcatcher)

## Ruby and Bundler

The easiest way to manage different installations of Ruby (we think) is with [rbenv](https://github.com/rbenv/rbenv).

1. Follow the installation instructions on the [rbenv repo](https://github.com/rbenv/rbenv)
1. Restart your terminal, then, in the root directory of the repository:
    ```
    rbenv install
    gem install bundler
    bundle install
    ```
`rbenv` will handle installing Ruby and switching to it for you when you enter the repo (so no need to worry about your other Ruby installs!).

If you run into a problem where your bundle install says you're on an older version of bundler than what's in the lockfile, run `gem update --system` to update RubyGems, then:
`gem install bundler:[latest-version-you-want]`, e.g. `gem install bundler:2.1.2`

Depending on your system, you might have trouble building the `pg` gem, probably due to a missing `libpq-fe.h`. To get the necessary libraries installed:

* For Mac (Homebrew): `brew install postgresql`
* Debian/Ubuntu: `sudo apt-get install libpq-dev`
* On Enterprise Linux (CentOS/RHEL/Fedora/Amazon Linux/Sci Linux): `yum install postgresql-devel`

## Node and Yarn

The easiest way to manage different installations with node.js is with [nvm](https://github.com/nvm-sh/nvm). After following the installation instructions, type `nvm install` to install and run the right version of node.js.

You'll also need Yarn, a package manager for node.js. To install that:

* For Mac (Homebrew): `brew install yarn`
* Debian/Ubuntu:
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn
```
* On Enterprise Linux (CentOS/RHEL/Fedora/Amazon Linux/Sci Linux):
```
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install yarn
```

### Optional Support for asdf-vm

If you would like to use [asdf-vm](https://asdf-vm.com) to manage versions of `ruby`, `yarn` and `nodejs`, simply run `asdf install`. This will automatically install the necessary dependencies for you.

If you haven't setup `asdf` before, you will first need to follow the [installation instructions](https://asdf-vm.com/#/core-manage-asdf?id=install), then install plugins:
```
asdf plugin add ruby
asdf plugin add yarn
asdf plugin add nodejs
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
```
If you get an error about needing `GnuPG`, you will first have to install gnupg. Eg, on OS X, `brew install gpg`.

## Setting up PostgreSQL

### On OS X
We recommend:

* The [Postgres.app](Postgres.app), or
* Installing with [`homebrew`](https://wiki.postgresql.org/wiki/Homebrew).

### On Linux
1. Use your favorite package manager, eg:
    ```
    sudo apt-get update
    sudo apt-get install postgresql postgresql-contrib libpq-dev
    ```
2. Create a user for use with the mutual-aid app (or for other databases as well, if you like)
    ```
    # Choose a username and replace <username> below.
    # This will prompt for a password, make sure to remember it for later
    sudo -u postgres createuser <username> --pwprompt --createdb --no-superuser --no-createrole
    ```
3. Give the app knowledge of these creds:
    - Create or edit a `.env.local` file at the root of the project (alongside `.env`)
    - Set the following values to match the username and password from above.
    ```
    POSTGRES_USER=username
    POSTGRES_PASSWORD="password"
    ```
    - Note: the "quotes" around password are required if it contains spaces
4. Test the setup by ensuring the following runs without error:
    ```
    bin/rake db:setup
    ```

## Setting up Mailcatcher

Mailcatcher cannot be bundled, so has to be installed globally:
```
$ gem install mailcatcher
```

Start the mail server with:
```
$ mailcatcher
```
And go to http://localhost:1080/

By default, some user actions, such as registration, will fail if mailcatcher is not running.
This is an intentional choice to keep development as close to production as possible.
If you prefer to fire up mailcatcher only when you're working on emails, you can override this behavior
via [environment variables](#environment-variables).


## Environment variables

We've used the [dotenv](https://github.com/bkeepers/dotenv) gem to reference .env files in the main project level of the repo. Check out their README!

You can override any values in `.env` by introducing an `.env.local` file or more targetted files per environment, e.g. `.env.development.local`, `.env.test.local`.
All of these are already ignored in our repository so its safe to put credentials there (you can also use `chown/chmod` to further secure them).

Remember to configure environment variables in Heroku or wherever you deploy!
Only the development environment uses `.env` files.


## Running the App!

First, make sure local services or docker are running.

Then, to run the app locally:
```
$ bundle && yarn
$ bin/rake db:rebuild_and_seed_dev
$ bin/rails s # or, rails s -p 9000 (or whatever port you want to use that's not the default 3000)
```
And in a separate terminal:
```
$ bin/webpack-dev-server
```

You should now be able to see the app running at http://localhost:3000 (or whichever port the rails server is running on).


## Running tests
See [doc/testing.md](testing.md).


## Note about deprecation warnings.
Ruby 2.7 deprecated some commonly used syntax so our codebase currently spits out a _lot_ of warnings.

It will take some time for all our gems to get caught up, so in the meantime you might consider turning off deprecation warnings.
There are [several ways](https://www.andrewm.codes/posts/hiding-ruby-2-7-deprecation-warnings-in-rails-6-2mil/) to do this.

An alternative to the methods listed in the artice is to create an alias `alias nodep='export RUBYOPT="-W:no-deprecated"'`, giving
you the flexibility to toggle warnings in each terminal session as appropriate.


## Setting up Heroku (and using it for development)

The Rails and webpack processes can be launched with Heroku, if you choose to go that route. You can install Heroku Local using [these instructions](https://devcenter.heroku.com/articles/heroku-cli).


## Setting up other hosting

(If you've done this, please submit a PR so we can include instructions here!)


## Development with Docker

The application includes a pre-configured [docker-compose](https://docs.docker.com/compose/) environment for development. This environment includes descriptors for the application and its supporting services.

To get started using the application with docker,
1. Install [Docker](https://www.docker.com/get-started)
2. Install [docker-compose](https://docs.docker.com/compose/install/)
3. Clone the repository, and open the repository folder in your favorite command line or terminal application.

We provide helpful shorthand, binstubs to get started using and interacting with the local Docker development environment:

### Bootstrapping the application for development

```
bin/dev/bootstrap
```

Tears down any exiting images, containers, networks, etc. and sets everything up from scratch. This also seeds the development database. You can create a default admin account by setting `SYSTEM_EMAIL` and `SYSTEM_PASSWORD` values in `<project-root>/.env.local`:

```
SYSTEM_EMAIL=admin@mutualaid.localhost
SYSTEM_PASSWORD=mutualaid
```

then run the bootstrapping process.

**BEWARE**  This script is intended to be a quick way to start from nothing and get a working instance of the application - suitable for development - up and running. It is also appropriate if you should find yourself at a total loss and want to start over with your development environment. This destroys the volumes for the various containers - IE the data on the databases, gem caches, yarn caches will be erased. Additionally, reinstalling gems and yarn dependencies can take several minutes. 

### Starting the application and its services

```
bin/dev/serve
```

Starts the web application container and its supporting services - RDBMS, mailcatcher, etc.

Analogous to: `bin/rails server`

The application should be available at [https://localhost:3000](http://localhost:3000). You can sign in using the email and password you provided in the when you ran `bin/dev/bootstrap`. This docker compose also setups an a `mailcatcher` server, which you can access at `localhost:1080`. All emails will be delivered to mailcatcher, which should allow you to setup user accounts.

Additionally, if you want to keep the logs from each of the services separate, `bin/dev/serve` also takes an optional service name - or list of service names - to start in a single session. For example you might want to separate the `email`, and `webpacker` logs when interacting with a debugger in the `app` service to prevent losing the debugging context on log output from `email` or `webpacker`. In that case, you could open two separate terminals. In the first you would start the rails application:

```
bin/dev/serve app
```

and in the second terminal start `email` and `webpacker`

```
bin/dev/serve email webpacker
```

### Obtaining a shell

```
bin/dev/shell
```

Starts a shell inside the application container and establishes a TTY connection to it from the user's terminal.

Useful for things like starting a rails console, generating migrations, running one-off tests, exploring the container file system, etc. This will most likely be the tool you most-often reach for while developing with the local Docker development setup.

### Stopping the application and its services

```
bin/dev/stop
```

Stops the web application container and its supporting services - RDBMS, mailcatcher, webpacker, etc.


### Running tests

```
bin/dev/test
```

Runs the entire application test suite inside the context of the `app` container

Analogous to: `bin/test`

### Deleting all application resources

```
bin/dev/clean
```

Destroys all docker resources for the application and services.

### Notes

- Do not use this method in production! This is for **testing & development only** the configuration used with in this docker-compose file is highly insecure and should never be exposed to the public internet.
- All of the above binstubs are simply short hands for various `docker-compose` incantations - there's nothing stopping you from using `docker-compose` to interact with the services listed in the [`docker/development/docker-compose.yml`](../docker/development/docker-compose.yml).
- The application will save its state between successive invocations of `bin/dev/start`. This means that if you make changes to the database - for example by adding content or users - then those changes will persist the next time you start the application with `bin/dev/start`. You can wipe all the state of the application and all the services (including the postgres database) attached to it by running `bin/dev/clean` or `bin/dev/bootstrap` to start over from scratch. However, do be careful, because this will delete **all** the state saved in the application and database - and there is no way to retrieve it.

<sub>↩ Back to [README](/README.md)</sub>
