require "spec_helper"

RSpec.describe Breathe::Absences do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }

  describe "#list" do
    context "without any arguments" do
      let(:absences) { described_class.new(client).list }
      before { stub_absences_list }

      it "returns all absences" do
        expect(absences.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
      end

      it "gets the next page" do
        stub_absences_list("?page=2")
        next_page = absences.next_page
        expect(next_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"page" => "2"})
      end

      it "gets the last page" do
        stub_absences_list("?page=22")
        last_page = absences.last_page
        expect(last_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"page" => "22"})
      end
    end

    context "with a per_page argument" do
      let(:absences) { described_class.new(client).list(per_page: 10) }
      before { stub_absences_list("?per_page=10") }

      it "makes the request with the expected argument" do
        expect(absences.count).to eq(1)
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"per_page" => "10"})
      end
    end

    context "with a page argument" do
      let(:absences) { described_class.new(client).list(page: 2) }
      before { stub_absences_list("?page=2") }

      it "makes the expected request" do
        absences
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"page" => "2"})
      end
    end

    context "with filtering" do
      let(:date) { "2019-11-01" }
      let(:absences) { described_class.new(client).list(start_date: Date.parse(date), end_date: date) }
      before { stub_absences_list("?start_date=#{date}&end_date=#{date}") }

      it "makes the expected request" do
        absences
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/absences")
          .with(query: {"start_date" => date, "end_date" => date})
      end
    end
  end

  def stub_absences_list(query_string = "")
    stub_request(:get, "https://api.breathehr.com/v1/absences#{query_string}")
      .to_return(
        body: JSON.parse(File.read(File.join("spec", "fixtures", "absences.json"))).to_json,
        headers: {
          "Content-Type" => "application/json",
          "X-Api-Key" => breathe_api_key,
          "Link" => "<https://api.breathehr.com/v1/absences?page=1>; rel=\"first\", <https://api.breathehr.com/v1/absences?page=1>; rel=\"prev\", <https://api.breathehr.com/v1/absences?page=22>; rel=\"last\", <https://api.breathehr.com/v1/absences?page=2>; rel=\"next\"",
        }
      )
  end
end
