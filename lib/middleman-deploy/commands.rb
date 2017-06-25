require 'middleman-core/cli'
require 'middleman-core/rack' if Middleman::VERSION.to_i > 3
require 'middleman-deploy/pkg-info'
require 'middleman-deploy/extension'
require 'middleman-deploy/methods'
require 'middleman-deploy/strategies'

module Middleman
  module Cli
    # This class provides a "deploy" command for the middleman CLI.
    class Deploy < Thor::Group
      include Thor::Actions

      check_unknown_options!

      namespace :deploy

      class_option :environment,
                 aliases: '-e',
                 default: ENV['MM_ENV'] || ENV['RACK_ENV'] || 'production',
                 desc: 'The environment Middleman will run under'

      class_option :verbose,
                   type: :boolean,
                   default: false,
                   desc: 'Print debug messages'

      class_option :instrument,
                   type: :string,
                   default: false,
                   desc: 'Print instrument messages'

      class_option :build_before,
        type: :boolean,
        aliases: '-b',
        desc: 'Run `middleman build` before the deploy step'

      def self.subcommand_help(_options)
        # TODO
      end

      # Tell Thor to exit with a nonzero exit code on failure
      def self.exit_on_failure?
        true
      end

      def deploy
        env = options['environment'] ? :production : options['environment'].to_s.to_sym
        verbose = options['verbose'] ? 0 : 1
        instrument = options['instrument']

        @app = ::Middleman::Application.new do
          config[:mode] = :build
          config[:environment] = env
          ::Middleman::Logger.singleton(verbose, instrument)
        end
        build_before(options)
        process
      end

      protected

      def build_before(options = {})
        build_enabled = options.fetch('build_before', deploy_options.build_before)

        if build_enabled
          # http://forum.middlemanapp.com/t/problem-with-the-build-task-in-an-extension
          run("middleman build -e #{options['environment']}") || exit(1)
        end
      end

      def print_usage_and_die(message)
        fail StandardError, "ERROR: #{message}\n#{Middleman::Deploy::README}"
      end

      def process
        server_instance   = @app
        camelized_method  = deploy_options.deploy_method.to_s.split('_').map(&:capitalize).join
        method_class_name = "Middleman::Deploy::Methods::#{camelized_method}"
        method_instance   = method_class_name.constantize.new(server_instance, deploy_options)

        method_instance.process
      end

      def deploy_options
        options = nil

        begin
          options = ::Middleman::Deploy.options
        rescue NoMethodError
          print_usage_and_die 'You need to activate the deploy extension in config.rb.'
        end

        unless options.deploy_method
          print_usage_and_die 'The deploy extension requires you to set a method.'
        end

        case options.deploy_method
        when :rsync, :sftp
          unless options.host && options.path
            print_usage_and_die "The #{options.deploy_method} method requires host and path to be set."
          end
        when :ftp
          unless options.host && options.user && options.password && options.path
            print_usage_and_die 'The ftp deploy method requires host, path, user, and password to be set.'
          end
        end

        options
      end
    end

    # Add to CLI
    Base.register(Middleman::Cli::Deploy, 'deploy', 'deploy [options]', Middleman::Deploy::TAGLINE)

    # Alias "d" to "deploy"
    Base.map('d' => 'deploy')
  end
end
