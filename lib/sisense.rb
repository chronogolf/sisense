require 'virtus'
require 'sisense/utils/string'
require 'sisense/version'
require 'sisense/api/client'
require 'sisense/api/resource'

require 'sisense/dataset'
require 'sisense/group'
require 'sisense/elasticube'

module Sisense
  @access_token = nil
  @base_uri = nil

  class << self
    attr_accessor :access_token, :base_uri
  end
end
