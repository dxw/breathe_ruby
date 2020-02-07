require "spec_helper"

RSpec.describe Breathe::EmployeeTrainingCourses do
  let(:client) { Breathe::Client.new(api_key: breathe_api_key) }
  let(:breathe_api_key) { "foo" }

  describe "#list" do
    context "without any arguments" do
      let(:training_courses) { described_class.new(client).list }
      before { stub_employee_training_courses_list }

      it "returns all sicknesses" do
        expect(training_courses.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employee_training_courses")
      end

      it "gets the next page" do
        stub_employee_training_courses_list("?page=2")

        next_page = training_courses.next_page
        expect(next_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employee_training_courses")
          .with(query: {"page" => "2"})
      end

      it "gets the last page" do
        stub_employee_training_courses_list("?page=22")

        last_page = training_courses.last_page
        expect(last_page.count).to eq(1)

        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employee_training_courses")
          .with(query: {"page" => "22"})
      end
    end

    context "with a per_page argument" do
      let(:training_courses) { described_class.new(client).list(per_page: 10) }
      before { stub_employee_training_courses_list("?per_page=10") }

      it "returns the expected number of sicknesses" do
        expect(training_courses.count).to eq(1)
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employee_training_courses")
          .with(query: {"per_page" => "10"})
      end
    end

    context "with a page argument" do
      let(:training_courses) { described_class.new(client).list(page: 2) }
      before { stub_employee_training_courses_list("?page=2") }

      it "makes the expected request" do
        training_courses
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employee_training_courses")
          .with(query: {"page" => "2"})
      end
    end

    context "with filtering" do
      let(:date) { "2019-11-01" }
      let(:training_courses) { described_class.new(client).list(start_date: Date.parse(date), end_date: date) }
      before { stub_employee_training_courses_list("?start_date=#{date}&end_date=#{date}") }

      it "makes the expected request" do
        training_courses
        expect(WebMock).to have_requested(:get, "https://api.breathehr.com/v1/employee_training_courses")
          .with(query: {"start_date" => date, "end_date" => date})
      end
    end
  end

  def stub_employee_training_courses_list(query_string = "")
    stub_request(:get, "https://api.breathehr.com/v1/employee_training_courses#{query_string}")
      .to_return(
        body: JSON.parse(File.read(File.join("spec", "fixtures", "employee_training_courses.json"))).to_json,
        headers: {
          "Content-Type" => "application/json",
          "X-Api-Key" => breathe_api_key,
          "Link" => "<https://api.breathehr.com/v1/employee_training_courses?page=1>; rel=\"first\", <https://api.breathehr.com/v1/employee_training_courses?page=1>; rel=\"prev\", <https://api.breathehr.com/v1/employee_training_courses?page=22>; rel=\"last\", <https://api.breathehr.com/v1/employee_training_courses?page=2>; rel=\"next\"",
        }
      )
  end
end
