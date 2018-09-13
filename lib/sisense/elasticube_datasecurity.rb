module Sisense
  class ElasticubeDatasecurity < API::NestedResource
    RESOURCE_NAME = 'datasecurity'.freeze
    PARENT_CLASS = Sisense::Elasticube

    def self.list(server: 'LocalHost', elasticube_title:)
      path = [resource_base_path(use_legacy_api: true), server, elasticube_title, 'datasecurity'].join('/')
      response = api_client.get(path)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
