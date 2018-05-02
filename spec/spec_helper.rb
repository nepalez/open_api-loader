require "bundler/setup"
require "pry"
require "webmock/rspec"
require "open_api/loader"
require "rspec/its"

require_relative "support/fixture_helpers"
require_relative "support/path_helpers"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.order = :random
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
