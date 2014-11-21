module Middleman
  module Deploy
    module Strategies
      module Git
        class Base
          attr_accessor :branch, :build_dir, :remote, :commit_message, :user_name, :user_email

          def initialize(build_dir, remote, branch, commit_message)
            self.branch         = branch
            self.build_dir      = build_dir
            self.remote         = remote
            self.commit_message = commit_message
            self.user_name      = `git config --get user.name`
            self.user_email     = `git config --get user.email`
          end

          def process
            raise NotImplementedError
          end

          protected

          def add_signature_to_commit_message(base_message)
            signature = "#{Middleman::Deploy::PACKAGE} #{Middleman::Deploy::VERSION}"
            time      = "#{Time.now.utc}"

            "#{base_message} at #{time} by #{signature}"
          end

          def checkout_branch
            # if there is a branch with that name, switch to it, otherwise create a new one and switch to it
            if `git branch`.split("\n").any? { |b| b =~ /#{self.branch}/i }
              `git checkout #{self.branch}`
            else
              `git checkout -b #{self.branch}`
            end
          end

          def commit_branch(options = '')
            message = self.commit_message ? self.commit_message : add_signature_to_commit_message('Automated commit')

            run_or_fail("git add -A")
            run_or_fail("git commit --allow-empty -am \"#{message}\"")
            run_or_fail("git push #{options} origin #{self.branch}")
          end

          private
          def run_or_fail(command)
            system(command) || raise("ERROR running: #{command}")
          end
        end
      end
    end
  end
end
