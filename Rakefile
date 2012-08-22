require 'bundler'
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
  t.cucumber_opts = "--color --tags ~@wip --strict --format #{ENV['CUCUMBER_FORMAT'] || 'Fivemat'}"
end

require 'rake/clean'

task :test => ["cucumber"]

require "middleman-deploy/pkg-info"

PACKAGE = "#{Middleman::Deploy::PACKAGE}"
VERSION = "#{Middleman::Deploy::VERSION}"

task :package do
  system "gem build #{PACKAGE}.gemspec"
end

task :install => :package do
  Dir.chdir("pkg") do
    system "gem install #{PACKAGE}-#{VERSION}"
  end
end

task :release => :package do
  Dir.chdir("pkg") do
    system "gem push #{PACKAGE}-#{VERSION}"
  end
end

task :default => :test
