module Sisense
  module API
    class NestedResource < Resource
      def self.resource_base_path(use_legacy_api: false)
        raise NotImplementedError, "Sisense::API::NestedResource is an abstract class" if self == NestedResource

        path_base = use_legacy_api ? "/api/" : "/api/v1/"
        path_base + self::PARENT_CLASS::RESOURCE_NAME
      end
    end
  end
end
