# Require core library
require "middleman-core"

# Extension namespace
module Middleman
  module Deploy

    class Options < Struct.new(:whatisthis, :method, :host, :port, :user, :password, :path, :clean, :remote, :branch, :after_build); end

    class << self

      def options
        @@options
      end

      def registered(app, options_hash={}, &block)
        options = Options.new(options_hash)
        yield options if block_given?

        options.port ||= 22
        options.clean ||= false
        options.remote ||= "origin"
        options.branch ||= "gh-pages"

        options.after_build ||= false

        app.after_build do |builder|
          ::Middleman::Cli::Deploy.new.deploy if options.after_build
        end

        @@options = options

        app.send :include, Helpers
      end

      alias :included :registered

    end

    module Helpers
      def options
        ::Middleman::Deploy.options
      end
    end

  end
end
