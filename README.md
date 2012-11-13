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

First be sure that you have already placed your project under revision
control using git.

For example, for the default values of remote="master" and
branch="gh-pages", the output of `git branch -a` should look like:

      gh-pages
    * master
      remotes/origin/HEAD -> origin/master
      remotes/origin/gh-pages
      remotes/origin/master

This shows that "gh-pages" exists in the remote and local repos. There
needs to be at least one commit in "gh-pages" with which to start.

Edit `config.rb`, and add:

    activate :deploy do |deploy|
      deploy.method = :git
    end

#### These settings are optional.

To use a particular remote, add:

      deploy.remote = "some-other-remote-name"

Default is `origin`. Run `git remote -v` to see a list of possible
remotes.

To use a particular branch, add:

      deploy.branch = "some-other-branch-name"

Default is `gh-pages`. Run `git branch -a` to see a list of possible
branches.

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
