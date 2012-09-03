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
        send("deploy_#{self.middleman_options.method}")
      end

      protected

      def middleman_options
        ::Middleman::Application.server.inst.options
      end

      def deploy_rsync
        host = self.middleman_options.host
        port = self.middleman_options.port
        user = self.middleman_options.user
        path = self.middleman_options.path

        # These only exists when the config.rb sets them!
        if (!host || !user || !path)
          raise Thor::Error.new "You need to activate the deploy extension in config.rb"
        end

        command = "rsync -avze '" + "ssh -p #{port}" + "' build/ #{user}@#{host}:#{path}"

        if options.has_key? "clean"
          clean = options.clean
        else
          clean = self.middleman_options.clean
        end

        if clean
          command += " --delete"
        end

        run command
      end

      def deploy_git
        puts "## Deploying to Github Pages"
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
