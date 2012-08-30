# Require core library
require "middleman-core"

# Extension namespace
module Middleman
  module Deploy

    class Options < Struct.new(:method, :host, :port, :user, :path, :clean); end

    class << self

      def options
        @@options
      end

      def registered(app, options_hash={}, &block)
        options = Options.new(options_hash)
        yield options if block_given?

        options.method ||= :rsync
        options.port ||= 22
        options.clean ||= false

        @@options = options

        app.send :include, Helpers

        app.after_configuration do
          if (options.method == :rsync)
            if (!options.host || !options.user || !options.path)
              raise <<EOF


ERROR: middleman-deploy is not setup correctly. host, user, and path
*must* be set in config.rb. For example:

activate :deploy do |deploy|
  deploy.user = "tvaughan"
  deploy.host = "www.example.com"
  deploy.path = "/srv/www/site"
end

EOF
            end
          end
        end
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
