
module Middleman
  module Deploy
    module Credentials
      module Git
        class CacheHelper
          attr_accessor :timeout
          def initialize(timeout)
            self.timeout = timeout
          end
          def save_credentials
            unless credentials_active?
              `git config --global credential.helper 'cache --timeout=#{timeout}' `
              puts "Git credentials-helper has cached your data for #{timeout} seconds"
            else
              puts "Git credentials already active"
            end
          end

          def credentials_active?
            `git config --global credential.helper` != ''
          end
        end
      end
    end
  end
end
