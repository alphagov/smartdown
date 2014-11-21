$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'pathname'
require 'parslet/rig/rspec'
require 'support/model_builder'
require 'timecop'

RSpec.configure do |config|
  if config.files_to_run.one?
    config.full_backtrace = false
    config.default_formatter = 'doc'
  end

  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.include ModelBuilder::DSL
end
