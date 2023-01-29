require "bundler/setup"
require "simplecov"

SimpleCov.start

require "td_statement_extractor"
RSPEC_ROOT = File.dirname(__FILE__)

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
