
module Middleman
  module Deploy
    module Credentials
      module Git
        class NoneHelper
          def initialize(*args); end
          def save_credentials
            # No implementation for none helper
          end
        end
      end
    end
  end
end
