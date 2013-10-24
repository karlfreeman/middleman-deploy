module Middleman::Deploy::Strategy::RSync
  extend self

	def deploy(deploy_options, middleman_options, thor_context)
		host = deploy_options.host
		port = deploy_options.port
		path = deploy_options.path

    # Append "@" to user if provided.
    user = deploy_options.user
    user = "#{user}@" if user && !user.empty?

    dest_url = "#{user}#{host}:#{path}"

    puts "## Deploying via rsync to #{dest_url} port=#{port}"

    command = "rsync -avze '" + "ssh -p #{port}" + "' #{middleman_options.build_dir}/ #{dest_url}"

    if deploy_options.clean
    	command += " --delete"
    end

    thor_context.run command
  end

  def usage
    <<-EOS.gsub(/^ {6}/, '')
      # To deploy the build directory to a remote host via rsync:
      activate :deploy do |deploy|
        deploy.method = :rsync
        # host and path *must* be set
        deploy.host = "www.example.com"
        deploy.path = "/srv/www/site"
        # user is optional (no default)
        deploy.user = "tvaughan"
        # port is optional (default is 22)
        deploy.port  = 5309
        # clean is optional (default is false)
        deploy.clean = true
      end
    EOS
  end

  def required_options
    [:host, :path]
  end
end