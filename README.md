# middleman-deploy [![Build Status](https://travis-ci.org/tvaughan/middleman-deploy.png?branch=master)](https://travis-ci.org/tvaughan/middleman-deploy)

Deploys a [middleman](http://middlemanapp.com/) built site via **rsync**,
**ftp**, **sftp**, or **git** (e.g. gh-pages on github).

## Installation

Add this to the Gemfile of the repository of your middleman site:

```ruby
gem "middleman-deploy"
```

and run `bundle install`.

## Usage

```
$ middleman build [--clean]
$ middleman deploy [--build-before]
```

To automatically run `middleman build` during `middleman deploy`, turn on the
`build_before` option while activating the deploy extension:

```ruby
activate :deploy do |deploy|
  # ...
  deploy.build_before = true # default: false
end
```

## Possible Configurations

Middleman-deploy can deploy a site via rsync, ftp, sftp, or git.

### rsync

Make sure that `rsync` is installed, and activate the extension by adding the
following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host   = "www.example.com"
  deploy.path   = "/srv/www/site"
  # Optional Settings
  # deploy.user  = "tvaughan" # no default
  # deploy.port  = 5309 # ssh port, default: 22
  # deploy.clean = true # remove orphaned files on remote host, default: false
end
```

### Git (e.g. GitHub Pages)

Make sure that `git` is installed, and activate the extension by adding the
following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote = "custom-remote" # remote name or git url, default: origin
  # deploy.branch = "custom-branch" # default: gh-pages
end
```

If you use a remote name, you must first add it using `git remote add`. Run
`git remote -v` to see a list of possible remote names. If you use a git url,
it must end with '.git'.

Afterwards, the `build` directory will become a git repo. This branch will be
created on the remote if it doesn't already exist.

### FTP

Activate the extension by adding the following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.method   = :ftp
  deploy.host     = "ftp.example.com"
  deploy.path     = "/srv/www/site"
  deploy.user     = "tvaughan"
  deploy.password = "secret"
end
```

### SFTP

Activate the extension by adding the following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.method   = :sftp
  deploy.host     = "sftp.example.com"
  deploy.path     = "/srv/www/site"
  # Optional Settings
  # deploy.user     = "tvaughan" # no default
  # deploy.password = "secret" # no default
end
```

## Breaking Changes

* `v0.1.0`
    - Removed the `--clean` command-line option. This option only applied to
      the rsync deploy method. The idea going forward is that command-line
      options must apply to all deploy methods. Options that are specific to a
      deploy method will only be available in `config.rb`.
    - Removed `deploy` from the `after_build` hook. This caused a `deploy` to
      be run each time `build` was called. This workflow never made
      sense. `deploy` was added to the `after_build` hook simply because it
      was available.

## Thanks!

A **BIG** thanks to
[everyone who has contributed](https://github.com/tvaughan/middleman-deploy/graphs/contributors)!
Almost all pull requests are accepted.

## Other

Inspired by the rsync task in
[Octopress](https://github.com/imathis/octopress).
