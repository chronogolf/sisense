module Sisense
  class Elasticube < API::Resource
    RESOURCE_NAME = 'elasticubes'.freeze

    def self.list
      path = resource_base_path + '/getElasticubes'
      response = api_client.get(path)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
