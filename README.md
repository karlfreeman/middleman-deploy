# Middleman Deploy

Deploy your [Middleman](http://middlemanapp.com/) build via **rsync**, **ftp**, **sftp**, or **git** (e.g. [gh-pages on github](https://help.github.com/articles/creating-project-pages-manually)).

## Installation

```ruby
gem 'middleman-deploy', '~> 1.0'
```

## Usage

```
$ middleman build [--clean]
$ middleman deploy [--build-before]
```

## Possible Configurations

Middleman-deploy can deploy a site via rsync, ftp, sftp, or git. Checkout [the wiki](https://github.com/tvaughan/middleman-deploy/wiki/_pages) for advanced set-up options.

### Rsync

Make sure that `rsync` is installed, and activate the extension by adding the
following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.deploy_method = :rsync
  deploy.host          = 'www.example.com'
  deploy.path          = '/srv/www/site'
  # Optional Settings
  # deploy.user  = 'tvaughan' # no default
  # deploy.port  = 5309 # ssh port, default: 22
  # deploy.clean = true # remove orphaned files on remote host, default: false
  # deploy.flags = '-rltgoDvzO --no-p --del' # add custom flags, default: -avz
end
```

### Git (e.g. GitHub Pages)

Make sure that `git` is installed, and activate the extension by adding the
following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.deploy_method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end
```

If you use a remote name, you must first add it using `git remote add`. Run
`git remote -v` to see a list of possible remote names. If you use a git url,
it must end with '.git'.

Afterwards, the `build` directory will become a git repo.

If you use the force push strategy, this branch will be created on the remote if
it doesn't already exist.
But if you use the submodule strategy, you must first initialize build folder as
a submodule. See `git submodule add` documentation.

### FTP

Activate the extension by adding the following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.deploy_method   = :ftp
  deploy.host            = 'ftp.example.com'
  deploy.path            = '/srv/www/site'
  deploy.user            = 'tvaughan'
  deploy.password        = 'secret'
end
```

### SFTP

Activate the extension by adding the following to `config.rb`:

```ruby
activate :deploy do |deploy|
  deploy.deploy_method   = :sftp
  deploy.host            = 'sftp.example.com'
  deploy.port            = 22
  deploy.path            = '/srv/www/site'
  # Optional Settings
  # deploy.user     = 'tvaughan' # no default
  # deploy.password = 'secret' # no default
end
```

### Run Automatically

To automatically run `middleman build` during `middleman deploy`, turn on the
`build_before` option while activating the deploy extension:

```ruby
activate :deploy do |deploy|
  # ...
  deploy.build_before = true # default: false
end
```

### Multiple Environments

Deploy your site to more than one configuration using environment variables.

```ruby
# config.rb
case ENV['TARGET'].to_s.downcase
when 'production'
  activate :deploy do |deploy|
    deploy.deploy_method   = :rsync
    deploy.host            = 'www.example.com'
    deploy.path            = '/srv/www/production-site'
  end
else
  activate :deploy do |deploy|
    deploy.deploy_method   = :rsync
    deploy.host            = 'staging.example.com'
    deploy.path            = '/srv/www/staging-site'
  end
end
```

```ruby
# Rakefile
namespace :deploy do
  def deploy(env)
    puts "Deploying to #{env}"
    system "TARGET=#{env} bundle exec middleman deploy"
  end

  task :staging do
    deploy :staging
  end

  task :production do
    deploy :production
  end
end
```

```
$ rake deploy:staging
$ rake deploy:production
```

## Badges

[![Gem Version](http://img.shields.io/gem/v/middleman-deploy.svg)][gem]
[![Build Status](http://img.shields.io/travis/karlfreeman/middleman-deploy.svg)][travis]
[![Code Quality](http://img.shields.io/codeclimate/github/karlfreeman/middleman-deploy.svg)][codeclimate]
[![Code Coverage](http://img.shields.io/codeclimate/coverage/github/karlfreeman/middleman-deploy.svg)][codeclimate]
[![Gittip](http://img.shields.io/gittip/karlfreeman.svg)][gittip]

## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

- Ruby 2.1.0
- Ruby 2.0.0
- Ruby 1.9.3
- [JRuby][jruby]
- [Rubinius][rubinius]

# Credits

A **BIG** thanks to [everyone who has contributed](https://github.com/karlfreeman/middleman-deploy/graphs/contributors)! Almost all pull requests are accepted.

Inspiration:

- The rsync task in [Octopress](https://github.com/imathis/octopress)

[gem]: https://rubygems.org/gems/middleman-deploy
[travis]: http://travis-ci.org/karlfreeman/middleman-deploy
[codeclimate]: https://codeclimate.com/github/karlfreeman/middleman-deploy
[gittip]: https://www.gittip.com/karlfreeman
[jruby]: http://www.jruby.org
[rubinius]: http://rubini.us
