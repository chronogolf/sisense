require 'sisense/utils/string'
require 'sisense/version'
require 'sisense/api/client'
require 'sisense/api/resource'

require 'sisense/share'
require 'sisense/group'
require 'sisense/elasticube'

module Sisense
  @access_token = nil
  @base_uri = nil

  class << self
    attr_accessor :access_token, :base_uri

    def api_resources
      @api_resources ||= API::Resource.descendants.each_with_object({}) do |descendant, resources|
        resources[descendant::RESOURCE_NAME] = descendant
      end
    end
  end
end
