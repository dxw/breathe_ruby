RSpec.describe Breathe::Client, :vcr do
  let(:client) { @client }

  describe "absences" do
    it { expect(client.absences).to be_a(Breathe::Absences) }

    it "makes a request to the API" do
      client.absences.list
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
        .with(headers: {"Content-Type" => "application/json", "X-Api-Key" => ENV["BREATHE_API_KEY"]})
    end

    context "when auto_paginate is true" do
      let(:client) { Breathe::Client.new(api_key: ENV["BREATHE_API_KEY"], auto_paginate: true) }

      it "gets all pages" do
        absences = client.absences.list
        expect(absences.count).to eq(2137)
      end
    end
  end

  context "when the API key is incorrect" do
    let(:client) { Breathe::Client.new(api_key: "this-is-fake") }

    it "raises an error" do
      expect { client.absences.list }.to raise_error(
        Breathe::AuthenticationError,
        "The BreatheHR API returned a 401 error - are you sure you've set the correct API key?"
      )
    end
  end
end
