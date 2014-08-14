module Middleman
  module Deploy
    module Methods
      class Base
        attr_reader :options, :server_instance

        def initialize(server_instance, options = {})
          @options          = options
          @server_instance  = server_instance
        end

        def process
          raise NotImplementedError
        end
      end
    end
  end
end
