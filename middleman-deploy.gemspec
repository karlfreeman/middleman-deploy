# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-deploy/pkg-info"

Gem::Specification.new do |s|
  s.name        = Middleman::Deploy::PACKAGE
  s.version     = Middleman::Deploy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tom Vaughan"]
  s.email       = ["thomas.david.vaughan@gmail.com"]
  s.homepage    = "http://tvaughan.github.com/middleman-deploy/"
  s.summary     = %q{Deploy a middleman built site over rsync, ftp, or git (e.g. gh-pages on github).}
  s.description = %q{Deploy a middleman built site over rsync, ftp, or git (e.g. gh-pages on github).}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 3.0.0"])

  # Additional dependencies
  s.add_runtime_dependency("ptools")
end
