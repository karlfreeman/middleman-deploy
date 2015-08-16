module Middleman
  module Deploy
    module Methods
      class Base
        attr_reader :options, :server_instance

        def initialize(server_instance, options = {})
          @options          = options
          @server_instance  = server_instance
        end

        def build_dir
          server_instance.config.setting(:build_dir).value
        end

        def process
          fail NotImplementedError
        end
      end
    end
  end
end
