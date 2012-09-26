# Require core library
require "middleman-core"

# Extension namespace
module Middleman
  module Deploy

    class Options < Struct.new(:whatisthis, :method, :host, :port, :user, :path, :clean, :branch); end

    class << self

      def options
        @@options
      end

      def registered(app, options_hash={}, &block)
        options = Options.new(options_hash)
        yield options if block_given?

        options.port ||= 22
        options.clean ||= false
        options.branch ||= "gh-pages"

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
