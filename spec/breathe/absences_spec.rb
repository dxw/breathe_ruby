require "spec_helper"

RSpec.describe Breathe::Absences, :vcr do
  let(:client) { @client }

  describe "#list" do
    context "without any arguments" do
      let(:absences) { described_class.new(client).list }

      it "returns all absences" do
        expect(absences.count).to eq(100)
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
      end

      it "has pagination methods" do
        expect(absences.next_page).to eq(2)
        expect(absences.last_page).to eq(22)
        expect(absences.total).to eq(2129)
      end
    end

    context "with a per_page argument" do
      let(:absences) { described_class.new(client).list(per_page: 10) }

      it "returns the expected number of absences" do
        expect(absences.count).to eq(10)
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"per_page" => "10"})
      end

      it "has pagination methods" do
        expect(absences.next_page).to eq(2)
        expect(absences.last_page).to eq(213)
      end
    end

    context "with a page argument" do
      let!(:absences) { described_class.new(client).list(page: 2) }

      it "makes the expected request" do
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"page" => "2"})
      end

      it "has pagination methods" do
        expect(absences.next_page).to eq(3)
        expect(absences.last_page).to eq(22)
      end
    end

    context "with filtering" do
      let(:date) { "2019-11-01" }
      let!(:absences) { described_class.new(client).list(start_date: Date.parse(date), end_date: date) }

      it "makes the expected request" do
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"start_date" => date, "end_date" => date})
      end

      it "has pagination methods" do
        expect(absences.next_page).to eq(nil)
        expect(absences.last_page).to eq(nil)
      end
    end
  end
end
