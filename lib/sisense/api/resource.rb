module Sisense
  module API
    class Resource
      def self.api_client
        @client ||= Sisense::API::Client.new
      end

      def self.class_name
        name.split("::")[-1]
      end

      def self.resource_path(use_legacy_api: false)
        raise NotImplementedError, "Sisense::API::Resource is an abstract class" if self == Resource
        if use_legacy_api
          "/api/#{self::OBJECT_NAME.downcase.tr('.', '/')}s"
        else
          "/api/v1/#{self::OBJECT_NAME.downcase.tr('.', '/')}s"
        end
      end
    end
  end
end
