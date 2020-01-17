module Breathe
  class Employees
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      client.response(
        method: :get,
        path: "employees",
        args: args
      )
    end

    def get(id)
      client.response(
        method: :get,
        path: "employees/#{id.to_i}"
      )
    end
  end
end
