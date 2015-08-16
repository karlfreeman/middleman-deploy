require 'net/ftp'
require 'ptools'

module Middleman
  module Deploy
    module Methods
      class Ftp < Base
        attr_reader :host, :port, :pass, :path, :user

        def initialize(server_instance, options = {})
          super(server_instance, options)

          @host = self.options.host
          @user = self.options.user
          @pass = self.options.password
          @path = self.options.path
          @port = self.options.port
        end

        def process
          puts "## Deploying via ftp to #{user}@#{host}:#{path}"

          ftp = open_connection

          Dir.chdir(build_dir) do
            filtered_files.each do |filename|
              if File.directory?(filename)
                upload_directory(ftp, filename)
              else
                upload_binary(ftp, filename)
              end
            end
          end

          ftp.close
        end

        protected

        def filtered_files
          files = Dir.glob('**/*', File::FNM_DOTMATCH)

          files.reject { |filename| filename =~ Regexp.new('\.$') }
        end

        def handle_exception(exception, ftp, filename)
          reply     = exception.message
          err_code  = reply[0, 3].to_i

          if err_code == 550
            if File.binary?(filename)
              ftp.putbinaryfile(filename, filename)
            else
              ftp.puttextfile(filename, filename)
            end
          end
        end

        def open_connection
          ftp = Net::FTP.new(host)
          ftp.login(user, pass)
          ftp.chdir(path)
          ftp.passive = true

          ftp
        end

        def upload_binary(ftp, filename)
          begin
            ftp.putbinaryfile(filename, filename)
          rescue Exception => exception
            handle_exception(exception, ftp, filename)
          end

          puts "Copied #{filename}"
        end

        def upload_directory(ftp, filename)
          ftp.mkdir(filename)
          puts "Created directory #{filename}"
        rescue
        end
      end
    end
  end
end
