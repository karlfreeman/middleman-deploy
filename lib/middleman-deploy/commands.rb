require "middleman-core/cli"

require "middleman-deploy/extension"

require 'git'

module Middleman
  module Cli

    # This class provides a "deploy" command for the middleman CLI.
    class Deploy < Thor
      include Thor::Actions

      check_unknown_options!

      namespace :deploy

      # Tell Thor to exit with a nonzero exit code on failure
      def self.exit_on_failure?
        true
      end

      desc "deploy", "Copy build directory to a remote host"
      method_option "clean",
      :type => :boolean,
      :aliases => "-c",
      :desc => "Remove orphaned files or directories on the remote host"
      def deploy
        send("deploy_#{self.deploy_options.method}")
      end

      protected

      def print_usage_and_die(message)
        raise Error, "ERROR: " + message + "\n" + <<EOF

You should follow one of the two examples below to setup the deploy
extension in config.rb.

# To copy the build directory to a remote host:
activate :deploy do |deploy|
  deploy.method = :rsync
  # host, user, and path *must* be set
  deploy.user = "tvaughan"
  deploy.host = "www.example.com"
  deploy.path = "/srv/www/site"
  # clean is optional (default is false).
  deploy.clean = true
end

# To push to a remote gh-pages branch on GitHub:
activate :deploy do |deploy|
  deploy.method = :git
end
EOF
      end

      def deploy_options
        options = nil

        begin
          options = ::Middleman::Application.server.inst.options
        rescue
          print_usage_and_die "You need to activate the deploy extension in config.rb"
        end

        if (!options.method)
          print_usage_and_die "The deploy extension requires you to set a method"
        end

        if (options.method == :rsync)
          if (!options.host || !options.user || !options.path)
            print_usage_and_die "The rsync deploy method requires host, user, and path to be set"
          end
        end

        options
      end

      def deploy_rsync
        host = self.deploy_options.host
        port = self.deploy_options.port
        user = self.deploy_options.user
        path = self.deploy_options.path

        command = "rsync -avze '" + "ssh -p #{port}" + "' build/ #{user}@#{host}:#{path}"

        if options.has_key? "clean"
          clean = options.clean
        else
          clean = self.deploy_options.clean
        end

        if clean
          command += " --delete"
        end

        run command
      end

      def deploy_git
        puts "## Deploying to GitHub Pages"
        Dir.mktmpdir do |tmp|
          # clone ./ with branch gh-pages to tmp
          repo = Git.clone(ENV['MM_ROOT'], tmp)
          repo.checkout('origin/gh-pages', :new_branch => 'gh-pages')

          # copy ./build/* to tmp
          FileUtils.cp_r(Dir.glob(File.join(ENV['MM_ROOT'], 'build', '*')), tmp)

          # git add and commit in tmp
          repo.add
          repo.commit("Automated commit at #{Time.now.utc}")

          # push from tmp to self
          repo.push('origin', 'gh-pages')

          # push to github
          github_url = Git.open(ENV['MM_ROOT']).remote.url
          repo.add_remote('github', github_url)
          repo.push('github', 'gh-pages')
        end
      end

    end

    # Alias "d" to "deploy"
    Base.map({ "d" => "deploy" })

  end
end
