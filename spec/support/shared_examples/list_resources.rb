RSpec.shared_examples "list resources" do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }

  context "without any arguments" do
    let(:list) { described_class.new(client).list }
    before { stub_list_endpoint(resource_type, breathe_api_key) }

    it "returns all resources" do
      expect(list.count).to eq(1)

      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}")
    end

    it "gets the next page" do
      stub_list_endpoint(resource_type, breathe_api_key, "?page=2")

      next_page = list.next_page
      expect(next_page.count).to eq(1)

      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}")
        .with(query: {"page" => "2"})
    end

    it "gets the last page" do
      stub_list_endpoint(resource_type, breathe_api_key, "?page=22")

      last_page = list.last_page
      expect(last_page.count).to eq(1)

      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}")
        .with(query: {"page" => "22"})
    end
  end

  context "with a per_page argument" do
    let(:list) { described_class.new(client).list(per_page: 10) }
    before { stub_list_endpoint(resource_type, breathe_api_key, "?per_page=10") }

    it "returns the expected number of resources" do
      expect(list.count).to eq(1)
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}")
        .with(query: {"per_page" => "10"})
    end
  end

  context "with a page argument" do
    let(:list) { described_class.new(client).list(page: 2) }
    before { stub_list_endpoint(resource_type, breathe_api_key, "?page=2") }

    it "makes the expected request" do
      list
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}")
        .with(query: {"page" => "2"})
    end
  end

  context "with filtering" do
    let(:date) { "2019-11-01" }
    let(:list) { described_class.new(client).list(start_date: Date.parse(date), end_date: date) }
    before { stub_list_endpoint(resource_type, breathe_api_key, "?start_date=#{date}&end_date=#{date}") }

    it "makes the expected request" do
      list
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/#{resource_type}")
        .with(query: {"start_date" => date, "end_date" => date})
    end
  end
end
