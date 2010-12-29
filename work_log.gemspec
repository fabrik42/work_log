# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "work_log/version"

Gem::Specification.new do |s|
  s.name        = "work_log"
  s.version     = WorkLog::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christian Bäuerlein"]
  s.email       = ["fabrik42@gmail.com"]
  s.homepage    = "https://github.com/fabrik42/work_log"
  s.summary     = %q{A simple time tracker}
  s.description = %q{Log your work times to a file using a simple command line interface}

  s.add_dependency('chronic','>= 0.3.0')
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
