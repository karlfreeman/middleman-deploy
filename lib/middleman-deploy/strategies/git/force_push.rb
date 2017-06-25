module Middleman
  module Deploy
    module Strategies
      module Git
        class ForcePush < Base
          def process
            Dir.chdir(build_dir) do
              add_remote_url
              checkout_branch
              commit_branch('-f')
            end
          end

          private

          def add_remote_url
            url = get_remote_url

            unless File.exist?('.git')
              `git init`
              `git remote add origin #{url}`
              `git config user.name "#{user_name}"`
              `git config user.email "#{user_email}"`
            else
              # check if the remote repo has changed
              unless url == `git config --get remote.origin.url`.chop
                `git remote rm origin`
                `git remote add origin #{url}`
              end
              # check if the user name has changed
              `git config user.name "#{user_name}"` unless user_name == `git config --get user.name`
              # check if the user email has changed
              `git config user.email "#{user_email}"` unless user_email == `git config --get user.email`
            end
          end

          def get_remote_url
            remote  = self.remote
            url     = remote

            # check if remote is not a git url
            unless remote =~ /\.git$/
              url = `git config --get remote.#{url}.url`.chop
            end

            # if the remote name doesn't exist in the main repo
            if url == ''
              puts "Can't deploy! Please add a remote with the name '#{remote}' to your repo."
              exit
            end

            url
          end
        end
      end
    end
  end
end
