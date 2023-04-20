module Breathe
  class Response
    extend Forwardable
    attr_reader :response, :type

    delegate [:each, :find, :select, :count, :[], :concat] => :body

    def initialize(response:, type:)
      @response = response
      @type = type
    end

    def body
      @body ||= response.data[type]
    end

    def total
      response.headers["total"].to_i
    end

    def per_page
      response.headers["per-page"].to_i
    end

    def first_page
      get_page(:first)
    end

    def next_page
      get_page(:next)
    end

    def previous_page
      get_page(:prev)
    end

    def last_page
      get_page(:last)
    end

    def success?
      return true if /^2+/.match?(response.status.to_s)

      case response.status
      when 401
        raise Breathe::AuthenticationError, "The BreatheHR API returned a 401 error - are you sure you've set the correct API key?"
      else
        puts("Unknown Error")
        puts(response.status)
        puts(response.body)
        raise Breathe::UnknownError, "The BreatheHR API returned an unknown error"
      end
    end

    private

    def get_page(rel_type)
      self.class.new(response: response.rels[rel_type].get, type: type) if response.rels[rel_type]
    end
  end
end
