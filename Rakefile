require 'bundler'
Bundler::GemHelper.install_tasks

# require 'cucumber/rake/task'

# Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
#   t.cucumber_opts = "--color --tags ~@wip --strict --format #{ENV['CUCUMBER_FORMAT'] || 'Fivemat'}"
# end

require 'rake/clean'

# task :test => ["cucumber"]

require "middleman-deploy/pkg-info"

PACKAGE = "#{Middleman::Deploy::PACKAGE}"
VERSION = "#{Middleman::Deploy::VERSION}"

task :build do
  system "gem build #{PACKAGE}.gemspec"
end

task :install => :build do
  system "gem install pkg/#{PACKAGE}-#{VERSION}"
end

task :release => :build do
  system "gem push pkg/#{PACKAGE}-#{VERSION}"
end
