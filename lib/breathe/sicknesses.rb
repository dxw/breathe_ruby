module Breathe
  class Sicknesses
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      client.response(
        method: :get,
        path: "sicknesses",
        args: args
      )
    end
  end
end
