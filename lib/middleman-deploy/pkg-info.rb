module Middleman
  module Deploy
    PACKAGE = 'middleman-deploy'
    VERSION = '1.0.0'
    TAGLINE = 'Deploy a middleman built site over rsync, ftp, sftp, or git (e.g. gh-pages on github).'
    README = %Q{
You should follow one of the four examples below to setup the deploy
extension in config.rb.

# To deploy the build directory to a remote host via rsync:
activate :deploy do |deploy|
  deploy.method = :rsync
  # host and path *must* be set
  deploy.host = "www.example.com"
  deploy.path = "/srv/www/site"
  # user is optional (no default)
  deploy.user = "tvaughan"
  # port is optional (default is 22)
  deploy.port  = 5309
  # clean is optional (default is false)
  deploy.clean = true
  # flags is optional (default is -avze)
  deploy.flags = "-rltgoDvzO --no-p --del -e"
end

# To deploy to a remote branch via git (e.g. gh-pages on github):
activate :deploy do |deploy|
  deploy.method = :git
  # remote is optional (default is "origin")
  # run `git remote -v` to see a list of possible remotes
  deploy.remote = "some-other-remote-name"

  # branch is optional (default is "gh-pages")
  # run `git branch -a` to see a list of possible branches
  deploy.branch = "some-other-branch-name"

  # strategy is optional (default is :force_push)
  deploy.strategy = :submodule
end

# To deploy the build directory to a remote host via ftp:
activate :deploy do |deploy|
  deploy.method = :ftp
  # host, user, passwword and path *must* be set
  deploy.host = "ftp.example.com"
  deploy.path = "/srv/www/site"
  deploy.user = "tvaughan"
  deploy.password = "secret"
end

# To deploy the build directory to a remote host via sftp:
activate :deploy do |deploy|
  deploy.method = :sftp
  # host, user, passwword and path *must* be set
  deploy.host = "sftp.example.com"
  deploy.port = 22
  deploy.path = "/srv/www/site"
  # user is optional (no default)
  deploy.user = "tvaughan"
  # password is optional (no default)
  deploy.password = "secret"
end}
  end
end
