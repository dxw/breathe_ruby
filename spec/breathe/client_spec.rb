RSpec.describe Breathe::Client do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }
  let(:status) { 200 }
  let!(:stub) do
    stub_request(:get, url)
      .to_return(
        status: status,
        body: response.to_json,
        headers: headers
      )
  end
  let(:headers) { {"Content-Type" => "application/json", "X-Api-Key" => breathe_api_key} }
  let(:absences_json) { JSON.parse(File.read(File.join("spec", "fixtures", "absences.json"))) }

  describe "#absences" do
    let(:url) { "https://api.breathehr.com/v1/absences" }
    let(:response) { absences_json }

    it { expect(client.absences).to be_a(Breathe::Absences) }

    it "makes a request to the API" do
      absences = client.absences.list
      expect(stub).to have_been_requested
      expect(absences.count).to eq(1)
    end

    context "when auto_paginate is true" do
      let(:client) { Breathe::Client.new(api_key: breathe_api_key, auto_paginate: true) }
      let(:headers) { {"Content-Type" => "application/json", "Link" => "<#{second_page_url}>; rel=\"next\""} }
      let(:second_page_url) { "https://page2" }
      let!(:second_page_stub) do
        stub_request(:get, second_page_url)
          .to_return(
            status: status,
            body: absences_json.to_json,
            headers: {"Content-Type" => "application/json", "X-Api-Key" => breathe_api_key}
          )
      end

      it "gets all pages" do
        absences = client.absences.list
        expect(second_page_stub).to have_been_requested
        expect(absences.count).to eq(2)
      end
    end
  end

  context "when the API key is incorrect" do
    let(:response) { {error: "401 Unauthorized"}.to_json }
    let(:status) { 401 }
    let(:url) { "https://api.breathehr.com/v1/absences" }

    it "raises an error" do
      expect { client.absences.list }.to raise_error(
        Breathe::AuthenticationError,
        "The BreatheHR API returned a 401 error - are you sure you've set the correct API key?"
      )
    end
  end
end
