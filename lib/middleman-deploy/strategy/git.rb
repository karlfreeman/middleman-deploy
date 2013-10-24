module Middleman::Deploy::Strategy::Git
  extend self

  def deploy(deploy_options, middleman_options)

    remote = deploy_options.remote
    branch = deploy_options.branch

    puts "## Deploying via git to remote=\"#{remote}\" and branch=\"#{branch}\""

    #check if remote is not a git url
    unless remote =~ /\.git$/
      remote = `git config --get remote.#{remote}.url`.chop
    end

    #if the remote name doesn't exist in the main repo
    if remote == ''
      puts "Can't deploy! Please add a remote with the name '#{deploy_options.remote}' to your repo."
      exit
    end

    Dir.chdir(middleman_options.build_dir) do
      unless File.exists?('.git')
        `git init`
        `git remote add origin #{remote}`
      else
        #check if the remote repo has changed
        unless remote == `git config --get remote.origin.url`.chop
          `git remote rm origin`
          `git remote add origin #{remote}`
        end
      end

      #if there is a branch with that name, switch to it, otherwise create a new one and switch to it
      if `git branch`.split("\n").any? { |b| b =~ /#{branch}/i }
        `git checkout #{branch}`
      else
        `git checkout -b #{branch}`
      end

      `git add -A`
      # '"message"' double quotes to fix windows issue
      `git commit --allow-empty -am '"Automated commit at #{Time.now.utc} by #{Middleman::Deploy::PACKAGE} #{Middleman::Deploy::VERSION}"'`
      `git push -f origin #{branch}`
    end
  end

  def usage
    <<-EOS.gsub(/^ {6}/, '')
      # To deploy to a remote branch via git (e.g. gh-pages on github):
      activate :deploy do |deploy|
        deploy.method = :git
        # remote is optional (default is "origin")
        # run `git remote -v` to see a list of possible remotes
        deploy.remote = "some-other-remote-name"
        # branch is optional (default is "gh-pages")
        # run `git branch -a` to see a list of possible branches
        deploy.branch = "some-other-branch-name"
      end
    EOS
  end

  def required_options
    []
  end
end