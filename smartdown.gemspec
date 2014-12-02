#encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smartdown/version'

Gem::Specification.new do |s|
  s.name        = 'smartdown'
  s.version     = Smartdown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2014-07-09'
  s.summary     = "Interactive question-answer flows using markdown-like external DSL"
  s.authors     = ["David Heath"]
  s.homepage    = "https://github.com/alphagov/smartdown"
  s.email       = 'david.heath@digital.cabinet-office.gov.uk'
  s.files       = Dir["{app,lib,bin}/**/*"] + ["LICENSE.md", "README.md"]
  s.test_files    = Dir["{spec}/**/*"]
  s.executables = ["smartdown"]
  s.bindir      = 'bin'
  s.require_paths = ["lib"]
  s.license       = 'MIT'
  s.add_runtime_dependency 'parslet', '~> 1.6.1'
  s.add_development_dependency "rspec", "~> 3.0.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "gem_publisher"
  s.add_development_dependency "timecop"
end
