module Middleman
  module Deploy
    module Methods
      class Git < Base
        def process
          puts "## Deploying via git to remote=\"#{self.options.remote}\" and branch=\"#{self.options.branch}\""

          camelized_strategy  = self.options.strategy.to_s.split('_').map { |word| word.capitalize}.join
          strategy_class_name = "Middleman::Deploy::Strategies::Git::#{camelized_strategy}"
          strategy_instance   = strategy_class_name.constantize.new(self.server_instance.build_dir, self.options.remote, self.options.branch, self.options.commit_message)

          strategy_instance.process
        end
      end
    end
  end
end
