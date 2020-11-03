require "bundler/setup"
require "sisense"
require "webmock/rspec"
require "vcr"
require "pry"

Dir[File.expand_path("support/**/*.rb", File.dirname(__FILE__))].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Sisense.hostname = "test-sisense.chronogolf.ca"
  Sisense.access_token = "sisense_access_token"

  VCR.configure do |vcr_config|
    vcr_config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    vcr_config.hook_into :webmock
  end
end
