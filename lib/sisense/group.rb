module Sisense
  class Group < API::Resource
    RESOURCE_NAME = 'groups'.freeze

    def self.list(params: nil)
      path = resource_base_path
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.retrieve(id:, params: nil)
      path = [resource_base_path, id].join('/')
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.create(params:)
      path = resource_base_path
      response = api_client.post(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
