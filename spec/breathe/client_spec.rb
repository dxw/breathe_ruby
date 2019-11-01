RSpec.describe Breathe::Client, :vcr do
  let(:client) { @client }

  describe "absences" do
    it { expect(client.absences).to be_a(Breathe::Absences) }

    it "makes a request to the API" do
      client.absences.list
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
        .with(headers: {"Content-Type" => "application/json", "X-Api-Key" => ENV["BREATHE_API_KEY"]})
    end
  end
end
