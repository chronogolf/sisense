module Sisense
  class Elasticube < API::Resource
    include Virtus.model

    OBJECT_NAME = 'elasticube'.freeze

    attribute :id, String
    attribute :title, String
    attribute :fullname, String
    attribute :address, String
    attribute :database, String

    def self.metadata
      response = api_client.get(resource_path(use_legacy_api: true) + "/#{__method__.to_s}")
      JSON.parse(response.body).map do |hash_item|
        self.new(self.sanitized_hash(hash_item))
      end
    end

    def self.sanitized_hash(hash)
      hash.tap do |h|
        h.keys.each { |key| h[key.underscore] = h.delete(key) }
      end
    end
  end
end
