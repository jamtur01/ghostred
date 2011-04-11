# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ghostred/version"

Gem::Specification.new do |s|
  s.name        = "ghostred"
  s.version     = Ghostred::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "James Turnbull"
  s.email       = "james@lovedthanlost.net"
  s.homepage    = ""
  s.summary     = %q{Monitors GitHub Pull Requests and turns them into Redmine tickets}
  s.description = %q{Monitors GitHub Pull Requests and turns them into Redmine tickets}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency('octokit')
  s.add_runtime_dependency('redmine_client')
end
