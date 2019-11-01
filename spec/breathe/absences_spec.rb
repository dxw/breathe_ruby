require "spec_helper"

RSpec.describe Breathe::Absences, :vcr do
  let(:client) { @client }

  describe "#list" do
    it "returns all absences" do
      absences = described_class.new(client).list
      expect(absences.count).to eq(100)
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
    end

    it "allows a per_page argument" do
      absences = described_class.new(client).list(per_page: 10)
      expect(absences.count).to eq(10)
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
        .with(query: {"per_page" => "10"})
    end

    it "allows a page argument" do
      described_class.new(client).list(page: 2)
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
        .with(query: {"page" => "2"})
    end

    it "allows filtering" do
      described_class.new(client).list(start_date: Date.today, end_date: Date.today)
      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
        .with(query: {"start_date" => Date.today.to_s, "end_date" => Date.today.to_s})
    end
  end
end
