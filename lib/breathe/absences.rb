module Breathe
  class Absences
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      client.response(
        method: :get,
        path: "absences",
        args: args
      )
    end
  end
end
