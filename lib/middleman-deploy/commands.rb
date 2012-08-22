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
      def deploy
        options = ::Middleman::Application.server.inst.options

        # These only exists when the config.rb sets them!
        if (options.host && options.user && options.path)
          run "rsync -avze '" + "ssh -p #{options.port}" + "' #{"--delete" if options.delete == true} build/ #{options.user}@#{options.host}:#{options.path}"
        else
          raise Thor::Error.new "You need to activate the deploy extension in config.rb "
        end
      end
    end

    # Alias "d" to "deploy"
    Base.map({ "d" => "deploy" })
  end
end
