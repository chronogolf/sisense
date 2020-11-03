module Sisense
  class User < API::Resource
    RESOURCE_NAME = "users".freeze

    def self.list(params: nil)
      path = resource_base_path
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.retrieve(id:, params: nil)
      path = [resource_base_path, id].join("/")
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.create(params:)
      path = resource_base_path
      response = api_client.post(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.update(id:, params:)
      path = [resource_base_path, id].join("/")
      response = api_client.patch(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.delete(id:)
      path = [resource_base_path, id].join("/")
      api_client.delete(path)
    end
  end
end
