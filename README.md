Middleman Delpoy -- Deploy a [middleman](http://middlemanapp.com/) built site over rsync.

[![Build Status](https://secure.travis-ci.org/tvaughan/middleman-deploy.png)](http://travis-ci.org/tvaughan/middleman-deploy)

===

## QUICK START

If deploying through `rsync`, be sure it is installed.

### Step 1

    gem install middleman-deploy

### Step 2

    middleman init example-site
    cd example-site

### Step 3

Edit `Gemfile`, and add:

    gem "middleman-deploy"

Then run:

    bundle install

### Step 4a - Rsync setup

#### These settings are required.

Edit `config.rb`, and add:

    activate :deploy do |deploy|
      deploy.method = :rsync
      deploy.user   = "tvaughan"
      deploy.host   = "www.example.com"
      deploy.path   = "/srv/www/site"
    end

Adjust these values accordingly.

#### These settings are optional.

To use a particular SSH port, add:

      deploy.port = 5309

Default is `22`.

To remove orphaned files or directories on the remote host, add:

      deploy.clean = true

Default is `false`.

### Step 4b - Github Pages setup

Edit `config.rb`, and add:

    activate :deploy do |deploy|
      deploy.method = :git
    end

The git deploy method assumes your project is in a repository with
github set up as `origin` and a working `gh-pages` branch already in place.

### Step 5

    middleman build
    middleman deploy

### NOTES

Inspired by the rsync task in [Octopress](https://github.com/imathis/octopress).
