require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
  exempt_tags = ['--tags ~@wip']
  t.cucumber_opts = "--color #{exempt_tags.join(' ')} --strict --format #{ENV['CUCUMBER_FORMAT'] || 'Fivemat'}"
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
end

begin
  require 'rubocop/rake_task'
  desc 'Run rubocop'
  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
end

task default: :cucumber
task test: :cucumber
