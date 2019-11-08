require "vcr"

filter_vars = if File.file?(".env")
  dotenv = File.open(".env")
  Dotenv::Environment.new(dotenv, true)
else
  ENV
end

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.default_cassette_options = {record: :new_episodes}
  c.configure_rspec_metadata!
  filter_vars.each do |key, value|
    c.filter_sensitive_data("<#{key}>") { value }
    c.filter_sensitive_data("<#{key}>") { CGI.escape(value) }
  end
end

RSpec.configure do |config|
  config.after(:each) do |example|
    # Filter out JWT and bearer tokens from requests
    filter_vars = [
      "first_name",
      "last_name",
      "notes",
      "leave_reason",
      "email",
    ]
    if VCR.current_cassette&.recording?
      interactions = VCR.current_cassette.new_recorded_interactions
      interactions.each do |interaction|
        filter_vars.each do |var|
          interaction.response.body.gsub! Regexp.new("\"#{var}\":\".+\""), "\"first_name\":\"FILTERED\""
        end
      end
    end
  end
end
