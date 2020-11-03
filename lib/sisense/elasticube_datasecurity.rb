module Sisense
  class ElasticubeDatasecurity < API::NestedResource
    RESOURCE_NAME = "datasecurity".freeze
    PARENT_CLASS = Sisense::Elasticube

    def self.list(params: {})
      server = params[:server]
      title = params[:elasticube_title]
      path = [resource_base_path(use_legacy_api: true), server, title, "datasecurity"].join("/")
      response = api_client.get(path)
      api_client.parsed_response(response, object_class: self)
    end

    def self.create(params:)
      path = [resource_base_path(use_legacy_api: true), "datasecurity"].join("/")
      response = api_client.post(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.update(id:, params:)
      path = [resource_base_path(use_legacy_api: true), "datasecurity", id].join("/")
      response = api_client.put(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
