module Breathe
  class Client
    attr_reader :api_key, :last_response

    BASE_URL = "https://api.breathehr.com/v1/"

    def initialize(api_key:)
      @api_key = api_key
    end

    def absences
      @absences ||= Absences.new(self)
    end

    def response(type, path, args)
      response = request(type, path, query: args)

      return Response.new(response, path) if /^2+/.match?(response.status.to_s)

      case response.status
      when 401
        raise Breathe::AuthenticationError, "The BreatheHR API returned a 401 error - are you sure you've set the correct API key?"
      else
        raise Breathe::UnknownError, "The BreatheHR API returned an unknown error"
      end
    end

    def agent
      Sawyer::Agent.new(BASE_URL, links_parser: Sawyer::LinkParsers::Simple.new) do |http|
        http.headers["Content-Type"] = "application/json"
        http.headers["X-Api-Key"] = api_key
      end
    end

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query] = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
      end

      @last_response = response = agent.call(method, path, data, options)
      response
    end
  end
end
