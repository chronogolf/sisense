module Sisense
  class Dataset < API::Resource
    include Virtus.model

    OBJECT_NAME = 'dataset'.freeze

    attribute :_id, String
    attribute :name, String
    attribute :last_updated, Time
    attribute :oid, String
    attribute :elasticube, String
    attribute :type, String
    attribute :owner, String
    attribute :fullname, String
    attribute :connection, String


    def self.list
      response = api_client.get(resource_path)
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
