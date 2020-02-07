module Breathe
  class EmployeeTrainingCourses
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      client.response(
        method: :get,
        path: "employee_training_courses",
        args: args
      )
    end
  end
end
