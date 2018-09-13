require 'sisense/utils/string'
require 'sisense/version'
require 'sisense/api/client'
require 'sisense/api/resource'
require 'sisense/api/nested_resource'

require 'sisense/alert'
require 'sisense/connection'
require 'sisense/dashboard'
require 'sisense/dataset'
require 'sisense/elasticube'
require 'sisense/elasticube_datasecurity'
require 'sisense/folder'
require 'sisense/group'
require 'sisense/share'
require 'sisense/translation'
require 'sisense/user'
require 'sisense/widget'

module Sisense
  @access_token = nil
  @base_uri = nil

  class << self
    attr_accessor :access_token, :base_uri

    def api_resources
      @api_resources ||= API::Resource.descendants.each_with_object({}) do |descendant, resources|
        next if descendant == Sisense::API::NestedResource
        resources[descendant::RESOURCE_NAME] = descendant
      end
    end
  end
end
