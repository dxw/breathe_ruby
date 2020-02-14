RSpec.shared_examples "get a resource" do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }

  let(:get) { described_class.new(client).get(id) }
  let(:id) { "123" }

  before { stub_get_endpoint(resource_type, breathe_api_key, id) }

  it "returns a specific employee by id" do
    expect(get.count).to eq(1)

    expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}/123")
  end
end
