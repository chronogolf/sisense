module Sisense
  class Role < API::Resource
    RESOURCE_NAME = "roles".freeze

    def self.list(params: nil)
      path = resource_base_path(use_legacy_api: true)
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.retrieve(id:, params: nil)
      path = [resource_base_path(use_legacy_api: true), id].join("/")
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
