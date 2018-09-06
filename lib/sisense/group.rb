module Sisense
  class Group < API::Resource
    include Virtus.model

    OBJECT_NAME = 'group'.freeze

    attribute :_id, String
    attribute :role_id, String
    attribute :name, String
    attribute :ad, Boolean
    attribute :dn, String
    attribute :object_sid, String
    attribute :mail, String
    attribute :default_role, String
    attribute :language, String
    attribute :admins, Boolean
    attribute :everyone, Boolean
    attribute :created, Time
    attribute :last_updated, Time


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
