module Breathe
  class Absences
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      client.response(:get, "absences", args)
    end
  end
end
