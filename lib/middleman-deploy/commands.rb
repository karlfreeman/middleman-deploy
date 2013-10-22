require "middleman-core/cli"

require "middleman-deploy/extension"
require "middleman-deploy/pkg-info"
require "middleman-deploy/strategy"


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

      desc "deploy [options]", Middleman::Deploy::TAGLINE
      method_option "build_before",
      :type => :boolean,
      :aliases => "-b",
      :desc => "Run `middleman build` before the deploy step"

      def deploy
        if options.has_key? "build_before"
          build_before = options.build_before
        else
          build_before = self.deploy_options.build_before
        end
        if build_before
          # http://forum.middlemanapp.com/t/problem-with-the-build-task-in-an-extension
          run("middleman build") || exit(1)
        end

        strategies.find(deploy_options.method).deploy(self.deploy_options, self.inst, self)
      end

      protected

      def strategies
        ::Middleman::Deploy::Strategy
      end      

      def print_usage_and_die(message, strategy=nil)
        usage = if strategy
          [
            "You should follow this example below to setup the deploy",
            strategy.usage
          ].join("\n")
        else
          [
            "You should follow one of the four examples below to setup the deploy",
            "extension in config.rb.\n",
            *strategies.all.map(&:usage)
          ].join("\n")
        end

        error_message = "ERROR: #{message}\n\n#{usage}"

        raise Error, error_message
      end

      def inst
        ::Middleman::Application.server.inst
      end

      def deploy_options
        options = nil

        begin
          options = inst.options
        rescue NoMethodError
          print_usage_and_die "You need to activate the deploy extension in config.rb."
        end

        if (!options.method)
          print_usage_and_die "The deploy extension requires you to set a method."
        else
          strategy = strategies.find(options.method)
          missing_options = strategy.required_options - options.members
          unless missing_options.empty?
            print_usage_and_die "Missing options: #{missing_options.join(", ")}", strategy
          end
        end

        options
      end

      # Alias "d" to "deploy"
      Base.map({ "d" => "deploy" })
    end
  end
end
