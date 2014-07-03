module Middleman
  module Deploy
    module Methods
      class Rsync < Base

        attr_reader :clean, :flags, :hosts, :path, :port, :user

        def initialize(server_instance, options={})
          super(server_instance, options)

          @clean  = self.options.clean
          @flags  = self.options.flags
          @hosts  = [self.options.host].flatten
          @path   = self.options.path
          @port   = self.options.port
          @user   = self.options.user
        end

        def process
          [hosts].flatten.each do |host|
            process_host(host)
          end
        end

        protected

        def process_host(host)
          # Append "@" to user if provided.
          user      = "#{self.user}@" if self.user && !self.user.empty?

          dest_url  = "#{user}#{host}:#{self.path}"
          flags     = self.flags || '-avz'
          command   = "rsync #{flags} '-e ssh -p #{self.port}' #{self.server_instance.build_dir}/ #{dest_url}"

          if self.clean
            command += " --delete"
          end

          puts "## Deploying via rsync to #{dest_url} port=#{self.port}"
          system command
        end

      end
    end
  end
end
