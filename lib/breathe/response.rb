module Breathe
  class Response
    extend Forwardable
    attr_reader :data, :type, :response

    delegate [:each, :find, :select, :count, :[]] => :body

    def initialize(response, type)
      @response = response
      @data = JSON.parse(response.body)
      @type = type
    end

    def total
      response.headers["total"].to_i
    end

    def per_page
      response.headers.per_page
    end

    def next_page
      link_headers["next"].to_i unless link_headers.nil?
    end

    def last_page
      link_headers["last"].to_i unless link_headers.nil?
    end

    private

    def body
      data[type]
    end

    def link_headers
      @link_headers ||= begin
        return nil if response.headers["link"].nil?

        parse_link_headers(response.headers["link"])
      end
    end

    def parse_link_headers(header)
      header.split(",").map { |header|
        v, k = header.split(";")
        k = k.match("rel=\"(.+)\"")[1]
        v = v.match("page=([0-9]+)")[1]
        [k, v]
      }.to_h
    end
  end
end
