module Breathe
  class Response
    extend Forwardable
    attr_reader :response, :type

    delegate [:each, :find, :select, :count, :[]] => :body

    def initialize(response, type)
      @response = response
      @type = type
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

    private

    def get_page(rel_type)
      self.class.new(response.rels[rel_type].get, type) if response.rels[rel_type]
    end

    def body
      response.data[type]
    end
  end
end
