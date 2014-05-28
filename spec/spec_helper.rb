RSpec.configure do |config|
  if config.files_to_run.one?
    config.full_backtrace = true
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
