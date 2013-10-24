module Middleman::Deploy::Strategy::FTP
  extend self

	def deploy(deploy_options, middleman_options, thor_context)
		require 'net/ftp'
		require 'ptools'

		host = options.host
		user = options.user
		pass = options.password
		path = options.path

		puts "## Deploying via ftp to #{user}@#{host}:#{path}"

		ftp = Net::FTP.new(host)
		ftp.login(user, pass)
		ftp.chdir(path)
		ftp.passive = true

		Dir.chdir(middleman_options.build_dir) do
			files = Dir.glob('**/*', File::FNM_DOTMATCH)
			files.reject { |a| a =~ Regexp.new('\.$') }.each do |f|
				if File.directory?(f)
					begin
						ftp.mkdir(f)
						puts "Created directory #{f}"
					rescue
					end
				else
					begin
						if File.binary?(f)
							ftp.putbinaryfile(f, f)
						else
							ftp.puttextfile(f, f)
						end
					rescue Exception => e
						reply = e.message
						err_code = reply[0,3].to_i
						if err_code == 550
							if File.binary?(f)
								ftp.putbinaryfile(f, f)
							else
								ftp.puttextfile(f, f)
							end
						end
					end
					puts "Copied #{f}"
				end
			end
		end
		ftp.close
	end

  def usage
    <<-EOS.gsub(/^ {6}/, '')
      # To deploy the build directory to a remote host via ftp:
      activate :deploy do |deploy|
        deploy.method = :ftp
        # host, user, passwword and path *must* be set
        deploy.host = "ftp.example.com"
        deploy.path = "/srv/www/site"
        deploy.user = "tvaughan"
        deploy.password = "secret"
      end
    EOS
  end

  def required_options
    [:host, :path]
  end
end