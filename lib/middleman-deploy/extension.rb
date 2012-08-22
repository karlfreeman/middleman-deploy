# Require core library
require "middleman-core"

# Extension namespace
module Middleman
  module Deploy
    class Options < Struct.new(:delete, :host, :port, :user, :path); end

    class << self

      def registered(app, options_hash={}, &block)
        options = Options.new(options_hash)
        yield options if block_given?

        options.delete ||= false
        options.port ||= 22

        app.after_configuration do
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

        app.after_build do |builder|
          builder.run "rsync -avze '" + "ssh -p #{options.port}" + "' #{"--delete" if options.delete == true} build/ #{options.user}@#{options.host}:#{options.path}"
        end
      end
      alias :included :registered
    end

  end
end
