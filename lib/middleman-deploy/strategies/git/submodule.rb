module Middleman
  module Deploy
    module Strategies
      module Git
        class Submodule < Base
          def process
            Dir.chdir(build_dir) do
              checkout_branch
              pull_submodule
              commit_branch
            end

            commit_submodule
          end

          private

          def commit_submodule
            current_branch  = `git rev-parse --abbrev-ref HEAD`
            message         = add_signature_to_commit_message('Deployed')

            `git add #{build_dir}`
            `git commit --allow-empty -m "#{message}"`
            `git push origin #{current_branch}`
          end

          def pull_submodule
            `git fetch`
            `git stash`
            `git rebase #{remote}/#{branch}`
            `git stash pop`

            if $CHILD_STATUS.exitstatus == 1
              puts "Can't deploy! Please resolve conflicts. Then process to manual commit and push on #{branch} branch."
              exit
            end
          end
        end
      end
    end
  end
end
