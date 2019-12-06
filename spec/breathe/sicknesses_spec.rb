require "spec_helper"

RSpec.describe Breathe::Sicknesses do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }

  describe "#list" do
    context "without any arguments" do
      let(:sicknesses) { described_class.new(client).list }
      before { stub_sicknesses_list }

      it "returns all sicknesses" do
        expect(sicknesses.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/sicknesses")
      end

      it "gets the next page" do
        stub_sicknesses_list("?page=2")

        next_page = sicknesses.next_page
        expect(next_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/sicknesses")
          .with(query: {"page" => "2"})
      end

      it "gets the last page" do
        stub_sicknesses_list("?page=22")

        last_page = sicknesses.last_page
        expect(last_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/sicknesses")
          .with(query: {"page" => "22"})
      end
    end

    context "with a per_page argument" do
      let(:sicknesses) { described_class.new(client).list(per_page: 10) }
      before { stub_sicknesses_list("?per_page=10") }

      it "returns the expected number of sicknesses" do
        expect(sicknesses.count).to eq(1)
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/sicknesses")
          .with(query: {"per_page" => "10"})
      end
    end

    context "with a page argument" do
      let(:sicknesses) { described_class.new(client).list(page: 2) }
      before { stub_sicknesses_list("?page=2") }

      it "makes the expected request" do
        sicknesses
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/sicknesses")
          .with(query: {"page" => "2"})
      end
    end

    context "with filtering" do
      let(:date) { "2019-11-01" }
      let(:sicknesses) { described_class.new(client).list(start_date: Date.parse(date), end_date: date) }
      before { stub_sicknesses_list("?start_date=#{date}&end_date=#{date}") }

      it "makes the expected request" do
        sicknesses
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/sicknesses")
          .with(query: {"start_date" => date, "end_date" => date})
      end
    end
  end

  def stub_sicknesses_list(query_string = "")
    stub_request(:get, "https://api.breathehr.com/v1/sicknesses#{query_string}")
      .to_return(
        body: JSON.parse(File.read(File.join("spec", "fixtures", "sicknesses.json"))).to_json,
        headers: {
          "Content-Type" => "application/json",
          "X-Api-Key" => breathe_api_key,
          "Link" => "<https://api.breathehr.com/v1/sicknesses?page=1>; rel=\"first\", <https://api.breathehr.com/v1/sicknesses?page=1>; rel=\"prev\", <https://api.breathehr.com/v1/sicknesses?page=22>; rel=\"last\", <https://api.breathehr.com/v1/sicknesses?page=2>; rel=\"next\"",
        }
      )
  end
end
