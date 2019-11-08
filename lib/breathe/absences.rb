module Breathe
  class Absences
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      response = client.get("absences", args)
      Response.new(response, "absences")
    end
  end
end
