module Middleman::Deploy::Strategy::SFTP
  extend self

  def deploy(deploy_options, middleman_options, thor_context)
    require 'net/sftp'
    require 'ptools'

    host = deploy_options.host
    user = deploy_options.user
    pass = deploy_options.password
    path = deploy_options.path

    puts "## Deploying via sftp to #{user}@#{host}:#{path}"

    # `nil` is a valid value for user and/or pass.
    Net::SFTP.start(host, user, :password => pass) do |sftp|
      sftp.mkdir(path)
      Dir.chdir(middleman_options.build_dir) do
        files = Dir.glob('**/*', File::FNM_DOTMATCH)
        files.reject { |a| a =~ Regexp.new('\.$') }.each do |f|
          if File.directory?(f)
            begin
              sftp.mkdir("#{path}/#{f}")
              puts "Created directory #{f}"
            rescue
            end
          else
            begin
              sftp.upload(f, "#{path}/#{f}")
            rescue Exception => e
              reply = e.message
              err_code = reply[0,3].to_i
              if err_code == 550
                sftp.upload(f, "#{path}/#{f}")
              end
            end
            puts "Copied #{f}"
          end
        end
      end
    end
  end

  def usage
    <<-EOS.gsub(/^ {6}/, '')
      # To deploy the build directory to a remote host via sftp:
      activate :deploy do |deploy|
        deploy.method = :sftp
        # host, user, passwword and path *must* be set
        deploy.host = "sftp.example.com"
        deploy.path = "/srv/www/site"
        # user is optional (no default)
        deploy.user = "tvaughan"
        # password is optional (no default)
        deploy.password = "secret"
      end
    EOS
  end

  def required_options(options)
    [:host, :path]
  end
end