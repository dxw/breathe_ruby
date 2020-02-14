module Breathe
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def list(args = {})
      raise NotSupportedError unless self.class::SUPPORTED_ENDPOINTS.include?(:list)

      client.response(
        method: :get,
        path: resource_name,
        args: args
      )
    end

    def get(id)
      raise NotSupportedError unless self.class::SUPPORTED_ENDPOINTS.include?(:get)

      client.response(
        method: :get,
        path: "#{resource_name}/#{id.to_i}"
      )
    end

    private

    def resource_name
      @resource_name ||= self.class::RESOURCE_NAME
    end
  end
end
