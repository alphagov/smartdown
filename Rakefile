require 'rspec/core/rake_task'
require "gem_publisher"

RSpec::Core::RakeTask.new(:spec)

desc "Publish gem to RubyGems.org"
task :publish_gem do |t|
  gem = GemPublisher.publish_if_updated("smartdown.gemspec", :rubygems)
  puts "Published #{gem}" if gem
end

task :default => :spec
