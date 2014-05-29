require 'middleman-core/cli'

require 'middleman-deploy/pkg-info'
require 'middleman-deploy/extension'
require 'middleman-deploy/methods'
require 'middleman-deploy/strategies'

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

      desc 'deploy [options]', Middleman::Deploy::TAGLINE
      method_option 'build_before',
        type: :boolean,
        aliases: '-b',
        desc: 'Run `middleman build` before the deploy step'
      def deploy
        build_before(options)
        process
      end

      protected

      def build_before(options = {})
        build_enabled = options.fetch('build_before', self.deploy_options.build_before)

        if build_enabled
          # http://forum.middlemanapp.com/t/problem-with-the-build-task-in-an-extension
          run('middleman build') || exit(1)
        end
      end

      def print_usage_and_die(message)
        raise Error, "ERROR: #{message}\n#{Middleman::Deploy::README}"
      end

      def process
        server_instance   = ::Middleman::Application.server.inst

        camelized_method  = self.deploy_options.method.to_s.split('_').map { |word| word.capitalize}.join
        method_class_name = "Middleman::Deploy::Methods::#{camelized_method}"
        method_instance   = method_class_name.constantize.new(server_instance, self.deploy_options)

        method_instance.process
      end

      def deploy_options
        options = nil

        begin
          options = ::Middleman::Application.server.inst.options
        rescue NoMethodError
          print_usage_and_die 'You need to activate the deploy extension in config.rb.'
        end

        unless options.method
          print_usage_and_die 'The deploy extension requires you to set a method.'
        end

        case options.method
        when :rsync, :sftp
          unless options.host && options.path
            print_usage_and_die "The #{options.method} method requires host and path to be set."
          end
        when :ftp
          unless options.host && options.user && options.password && options.path
            print_usage_and_die 'The ftp deploy method requires host, path, user, and password to be set.'
          end
        end

        options
      end
    end

    # Alias "d" to "deploy"
    Base.map('d' => 'deploy')
  end
end
