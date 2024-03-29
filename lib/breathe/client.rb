module Breathe
  class Client
    attr_reader :api_key, :last_response

    BASE_URL = ENV.fetch("BREATHE_API_URL", "https://api.breathehr.com/v1/")

    def initialize(api_key:, auto_paginate: false)
      @api_key = api_key
      @auto_paginate = auto_paginate
    end

    def absences
      @absences ||= Absences.new(self)
    end

    def sicknesses
      @sicknesses ||= Sicknesses.new(self)
    end

    def employees
      @employees ||= Employees.new(self)
    end

    def employee_training_courses
      @employee_training_courses ||= EmployeeTrainingCourses.new(self)
    end

    def response(method:, path:, args: {})
      response = request(method: method, path: path, options: {query: args})
      parsed_response = Response.new(response: response, type: path.split("/").first)

      if parsed_response.success?
        @auto_paginate ? auto_paginated_response(parsed_response) : parsed_response
      end
    end

    def agent
      Sawyer::Agent.new(BASE_URL, links_parser: Sawyer::LinkParsers::Simple.new) do |http|
        http.headers["Content-Type"] = "application/json"
        http.headers["X-Api-Key"] = api_key
      end
    end

    def request(method:, path:, data: {}, options: {})
      @last_response = agent.call(method, path, data, options)
      @last_response
    end

    private

    def auto_paginated_response(parsed_response)
      pages = parsed_response

      while (next_page = parsed_response.next_page)
        break if next_page.nil?

        pages.concat(next_page.body)
        parsed_response = next_page
      end

      pages
    end
  end
end
