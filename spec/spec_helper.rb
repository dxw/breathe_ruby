require "bundler/setup"
require "breathe"
require "dotenv"
require "pry"
require "webmock/rspec"

Dotenv.load

require "support/shared_examples/list_resources"
require "support/shared_examples/get_a_resource"

require "support/stub_endpoints"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.alias_it_should_behave_like_to :it_can, "it can"
end
