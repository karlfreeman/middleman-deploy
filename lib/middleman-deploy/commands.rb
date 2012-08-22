require "middleman-core/cli"

require "middleman-deploy/extension"

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

      desc "deploy", "Deploy to a remote host over rsync"
      method_option "clean",
      :type => :boolean,
      :aliases => "-c",
      :desc => "Remove orphaned files or directories on the remote host"
      def deploy
        shared_inst = ::Middleman::Application.server.inst

        host = shared_inst.options.host
        port = shared_inst.options.port
        user = shared_inst.options.user
        path = shared_inst.options.path

        # These only exists when the config.rb sets them!
        if (!host || !user || !path)
          raise Thor::Error.new "You need to activate the deploy extension in config.rb "
        end

        command = "rsync -avze '" + "ssh -p #{port}" + "' build/ #{user}@#{host}:#{path}"

        if options.has_key? "clean"
          clean = options.clean
        else
          clean = shared_inst.options.clean
        end

        if clean
          command += "--delete"
        end

        run command
      end
    end

    # Alias "d" to "deploy"
    Base.map({ "d" => "deploy" })
  end
end
