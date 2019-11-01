module Breathe
  class Client
    BASE_URL = "https://api.breathehr.com/v1/"

    def initialize(api_key:)
      @api_key = api_key
    end

    def absences
      @_absences ||= Absences.new(connection)
    end

    def get(url, url_opts = {})
      request(:get, url, url_opts)
    end

    private

    attr_reader :api_key, :environment

    def connection
      Faraday.new(url: BASE_URL) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def request(method, url, url_opts = {})
      connection.send(method) do |req|
        req.url BASE_URL + url, url_opts
        req.headers["Content-Type"] = "application/json"
        req.headers["X-Api-Key"] = api_key
      end
    end
  end
end
