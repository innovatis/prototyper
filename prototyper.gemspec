# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "prototyper/version"

Gem::Specification.new do |s|
  s.name        = "prototyper"
  s.version     = Prototyper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Burke Libbey"]
  s.email       = ["burke@burkelibbey.org"]
  s.homepage    = ""
  s.summary     = %q{Generates core stuff more easily}
  s.description = %q{generators...}

  s.default_executable = "bin/prototyper"

  s.add_dependency "ripl"
  s.add_dependency "ripl-multi_line"
  s.add_dependency "ripl-irb"
  s.add_dependency "activesupport"
  s.add_dependency "sinatra/base"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
