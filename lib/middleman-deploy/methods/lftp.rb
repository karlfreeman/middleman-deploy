module Middleman
  module Deploy
    module Methods
      class Rsync < Base

        attr_reader :clean, :host, :path, :port, :user, :password, :protocol

        def initialize(server_instance, options={})
          super(server_instance, options)

          @clean    = self.options.clean
          @host     = self.options.host
          @path     = self.options.path
          @port     = self.options.port
          @user     = self.options.user
          @password = self.options.password
          @protocol = self.options.protocol.to_s

        end

        def process
          user = @user
          pass = @password
          # Append "@" to user if provided.
          if user && !user.empty?
            if pass && !pass.empty?
              user = "#{user}:"
              pass = "#{pass}@"
            else
              user = "#{user}@"
            end
          end

          dest_url = "#{@protocol}://#{user}#{pass}#{@host}"
          dest_url = "#{dest_url}:#{@port}" if @port

          puts "## Deploying via lftp to #{dest_url}"

          fail "build directory does not exists" unless File.exist?(self.server_instance.build_dir)

          command = <<-END
            lftp -c "set ftp:list-options -a;
                     set cmd:fail-exit yes;
                     open '#{dest_url}';
                     lcd #{self.server_instance.build_dir};
                     cd #{@path};
                     mirror --reverse #{@clean ? '--delete' : ''} --verbose;"
          END
          run command
        end
      end
    end
  end
end
