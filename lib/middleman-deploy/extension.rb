# Require core library
require 'middleman-core'

# Extension namespace
module Middleman
  module Deploy
    @options

    class << self
      attr_reader :options

      attr_writer :options
    end

    class Extension < Extension
      option :deploy_method, nil
      option :host, nil
      option :port, nil
      option :user, nil
      option :password, nil
      option :path, nil
      option :clean, nil
      option :remote, nil
      option :branch, nil
      option :strategy, nil
      option :build_before, nil
      option :flags, nil
      option :commit_message, nil

      def initialize(app, options_hash = {}, &block)
        super

        yield options if block_given?

        # Default options for the rsync method.
        options.port ||= 22
        options.clean ||= false

        # Default options for the git method.
        options.remote ||= 'origin'
        options.branch ||= 'gh-pages'
        options.strategy ||= :force_push
        options.commit_message ||= nil

        options.build_before ||= false
      end

      def after_configuration
        ::Middleman::Deploy.options = options
      end
    end
  end
end
