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
        shared_instance = ::Middleman::Application.server.inst

        # This only exists when the config.rb sets it!
        if shared_instance.respond_to? :deploy
          shared_instance.deploy(self)
        else
          raise Thor::Error.new "You need to activate the deploy extension in config.rb "
        end
      end
    end

    # Alias "d" to "deploy"
    Base.map({ "d" => "deploy" })
  end
end
