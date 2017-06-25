module Middleman
  module Deploy
    module Methods
      class Rsync < Base
        attr_reader :clean, :flags, :host, :path, :port, :user

        def initialize(server_instance, options = {})
          super(server_instance, options)

          @clean  = self.options.clean
          @flags  = self.options.flags
          @host   = self.options.host
          @path   = self.options.path
          @port   = self.options.port
          @user   = self.options.user
        end

        def process
          # Append "@" to user if provided.
          user      = "#{self.user}@" if user && !user.empty?

          dest_url  = "#{user}#{host}:#{path}"
          flags     = self.flags || '-avz'
          command   = "rsync #{flags} '-e ssh -p #{port}' #{build_dir}/ #{dest_url}"

          command += ' --delete' if clean

          puts "## Deploying via rsync to #{dest_url} port=#{port}"
          exec command
        end
      end
    end
  end
end
