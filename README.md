Middleman Delpoy -- Deploy a [middleman](http://middlemanapp.com/) built site over rsync or via git (e.g. gh-pages on github).

[![Build Status](https://secure.travis-ci.org/tvaughan/middleman-deploy.png)](http://travis-ci.org/tvaughan/middleman-deploy)

===

## QUICK START

### Step 1

    gem install middleman-deploy

### Step 2

    middleman init example-site
    cd example-site

### Step 3

Edit `Gemfile`, and add:

    gem "middleman-deploy", "~>0.0.1"

Then run:

    bundle install

### Step 4a - Rsync setup

First be sure that `rsync` is installed.

#### These settings are required.

Edit `config.rb`, and add:

    activate :deploy do |deploy|
      deploy.method = :rsync
      deploy.user = "tvaughan"
      deploy.host = "www.example.com"
      deploy.path = "/srv/www/site"
    end

Adjust these values accordingly.

#### These settings are optional.

To use a particular SSH port, add:

      deploy.port = 5309

Default is `22`.

To remove orphaned files or directories on the remote host, add:

      deploy.clean = true

Default is `false`.

### Step 4b - Git setup

Edit `config.rb`, and add:

    activate :deploy do |deploy|
      deploy.method = :git
    end

With this default configuration, it will deploy to the "origin/gh-pages" branch of
your current repo.

#### These settings are optional.

To use a particular remote, add:

      deploy.remote = "some-other-remote-name"

Default is `origin`. You can add a remote or a git url.
Run `git remote -v` to see a list of possible remotes or add a new one first.
If you specify a git url, be sure it ends with '.git'.

To use a particular branch, add:

      deploy.branch = "some-other-branch-name"

Default is `gh-pages`. If the branch doesn't exist remote, it will be created
for you.

### Step 4c - FTP setup

#### These settings are required.

Edit `config.rb`, and add:

    activate :deploy do |deploy|
      deploy.method = :ftp
      deploy.host = "ftp.example.com"
      deploy.user = "tvaughan"
      deploy.password = "secret"
      deploy.path = "/srv/www/site"
    end

Adjust these values accordingly.

### Step 5

    middleman build [--clean]
    middleman deploy [--clean]

### NOTES

Inspired by the rsync task in [Octopress](https://github.com/imathis/octopress).
