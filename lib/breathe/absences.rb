module Breathe
  class Absences
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      parse_response(client.get("absences", args))
    end

    private

    def parse_response(request)
      json = JSON.parse(request.body)
      json["absences"]
    end
  end
end
