require 'net/sftp'
require 'ptools'

module Middleman
  module Deploy
    module Methods
      class Sftp < Ftp
        def process
          puts "## Deploying via sftp to #{self.user}@#{self.host}:#{path}"

          # `nil` is a valid value for user and/or pass.
          Net::SFTP.start(self.host, self.user, password: self.pass, port: self.port) do |sftp|
            sftp.mkdir(self.path)

            Dir.chdir(self.server_instance.build_dir) do
              filtered_files.each do |filename|
                if File.directory?(filename)
                  upload_directory(sftp, filename)
                else
                  upload_file(sftp, filename)
                end
              end
            end
          end
        end

        protected

        def handle_exception(exception,filename, file_path)
          reply     = exception.message
          err_code  = reply[0, 3].to_i

          if err_code == 550
            sftp.upload(filename, file_path)
          end
        end

        def upload_directory(sftp, filename)
          file_path = "#{self.path}/#{filename}"

          begin
            sftp.mkdir(file_path)
            puts "Created directory #{filename}"
          rescue
          end
        end

        def upload_file(sftp, filename)
          file_path = "#{self.path}/#{filename}"

          begin
            sftp.upload(filename, file_path)
          rescue Exception => exception
            handle_exception(exception, filename, file_path)
          end

          puts "Copied #{filename}"
        end
      end
    end
  end
end
