module Middleman
  module Deploy
    module Methods
      class Git < Base
        def process
          puts "## Deploying via git to remote=\"#{options.remote}\" and branch=\"#{options.branch}\""

          camelized_strategy  = options.strategy.to_s.split('_').map(&:capitalize).join
          strategy_class_name = "Middleman::Deploy::Strategies::Git::#{camelized_strategy}"
          strategy_instance   = strategy_class_name.constantize.new(build_dir, options.remote, options.branch, options.commit_message)

          strategy_instance.process
        end
      end
    end
  end
end
