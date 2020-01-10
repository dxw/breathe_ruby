require "spec_helper"

RSpec.describe Breathe::Employees do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }

  describe "#list" do
    context "without any arguments" do
      let(:employees) { described_class.new(client).list }
      before { stub_employees_list }

      it "returns all employees" do
        expect(employees.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employees")
      end

      it "gets the next page" do
        stub_employees_list("?page=2")

        next_page = employees.next_page
        expect(next_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employees")
          .with(query: {"page" => "2"})
      end

      it "gets the last page" do
        stub_employees_list("?page=22")

        last_page = employees.last_page
        expect(last_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employees")
          .with(query: {"page" => "22"})
      end
    end

    context "with a per_page argument" do
      let(:employees) { described_class.new(client).list(per_page: 10) }
      before { stub_employees_list("?per_page=10") }

      it "returns the expected number of employees" do
        expect(employees.count).to eq(1)
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employees")
          .with(query: {"per_page" => "10"})
      end
    end

    context "with a page argument" do
      let(:employees) { described_class.new(client).list(page: 2) }
      before { stub_employees_list("?page=2") }

      it "makes the expected request" do
        employees
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employees")
          .with(query: {"page" => "2"})
      end
    end
  end

  describe "#get" do
    let(:get_employee) { described_class.new(client).get(id) }
    let(:id) { "123" }
    before { stub_employees_get(id) }

    it "returns a specific employee by id" do
      expect(get_employee.count).to eq(1)

      expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employees/123")
    end
  end

  def stub_employees_list(query_string = "")
    stub_request(:get, "https://api.breathehr.com/v1/employees#{query_string}")
      .to_return(
        body: JSON.parse(File.read(File.join("spec", "fixtures", "employees.json"))).to_json,
        headers: {
          "Content-Type" => "application/json",
          "X-Api-Key" => breathe_api_key,
          "Link" => "<https://api.breathehr.com/v1/employees?page=1>; rel=\"first\", <https://api.breathehr.com/v1/employees?page=1>; rel=\"prev\", <https://api.breathehr.com/v1/employees?page=22>; rel=\"last\", <https://api.breathehr.com/v1/employees?page=2>; rel=\"next\"",
        }
      )
  end

  def stub_employees_get(id)
    stub_request(:get, "https://api.breathehr.com/v1/employees/#{id}")
      .to_return(
        body: JSON.parse(File.read(File.join("spec", "fixtures", "employees.json"))).to_json,
        headers: {
          "Content-Type" => "application/json",
          "X-Api-Key" => breathe_api_key,
        }
      )
  end
end
