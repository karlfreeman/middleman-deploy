Middleman Deploy - Deploy a [middleman](http://middlemanapp.com/) built site over rsync, git (e.g. gh-pages on github) or via ftp.

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

    gem "middleman-deploy", "~> 0.0.12"

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

By default this will deploy to the `gh-pages` branch on the `origin`
remote. The `build` directory will become a git repo.

#### These settings are optional.

To use a particular remote, add:

      deploy.remote = "some-other-remote-name"

Default is `origin`. This can be a remote name or a git url.

If you use a remote name, you must first add it using `git remote
add`. Run `git remote -v` to see a list of possible remote names. If
you use a git url, it must end with '.git'.

To use a particular branch, add:

      deploy.branch = "some-other-branch-name"

Default is `gh-pages`. This branch will be created on the remote if it
doesn't already exist.

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

To automatically run middleman-deploy after `middleman build`, add:

      deploy.after_build = true

Default is `false`.

Please note that if the `--clean` or `--no-clean` option is passed to
`middleman build` it will not be passed to `middleman deploy`. For now
only the value of `deploy.clean` in `config.rb` will be used.

### NOTES

Inspired by the rsync task in [Octopress](https://github.com/imathis/octopress).
