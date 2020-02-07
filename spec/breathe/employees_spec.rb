require "spec_helper"

RSpec.describe Breathe::Employees do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }
  let(:resource_type) { "employees" }

  it_can "list resources"
  it_can "get a resource"
end
