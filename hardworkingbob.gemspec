# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hardworkingbob/version"

Gem::Specification.new do |s|
  s.name        = "hardworkingbob"
  s.version     = HardworkingBob::VERSION
  s.authors     = ["Emil Soman"]
  s.email       = ["emil.soman@gmail.com"]
  s.homepage    = "http://github.com/emilsoman/hardworkingbob"
  s.summary     = "HardworkingBob is a skype bot that does stuff for you"
  s.description = "HardworkingBob is a skype bot that does stuff for you. He lives a sad life."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.licenses      = ["MIT"]

  s.add_runtime_dependency "fakefs"
  s.add_runtime_dependency "faster_xml_simple"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "rype"
end
