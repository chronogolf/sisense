module Sisense
  class Group < API::Resource
    RESOURCE_NAME = 'groups'.freeze

    def self.list
      path = resource_base_path
      response = api_client.get(path)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
