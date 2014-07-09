#encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smartdown/version'

Gem::Specification.new do |s|
  s.name        = 'smartdown'
  s.version     = Smartdown::VERSION
  s.date        = '2014-07-09'
  s.summary     = "New smart answers framework with markdown-like external DSL"
  s.authors     = ["David Heath"]
  s.email       = 'david.heath@digital.cabinet-office.gov.uk'
  s.files         = Dir["{app,lib}/**/*"] + ["LICENSE.md", "README.md"]
  s.require_paths = ["lib"]
  s.license       = 'MIT'
end