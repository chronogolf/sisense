module Sisense
  module API
    class Resource
      def initialize(data = {})
        convert_to_obj(data)
      end

      def self.api_client
        @api_client ||= Sisense::API::Client.new
      end

      def self.class_name
        name.split('::')[-1]
      end

      def self.resource_base_path(use_legacy_api: false)
        raise NotImplementedError, 'Sisense::API::Resource is an abstract class' if self == Resource

        path_base = use_legacy_api ? '/api/' : '/api/v1/'
        path_base + self::RESOURCE_NAME
      end

      def self.descendants
        ObjectSpace.each_object(Class).select do |klass|
          klass < self && klass != Sisense::API::NestedResource
        end
      end

      def to_h
        instance_variables.each_with_object({}) do |instance_variable, h|
          key = instance_variable[1..instance_variable.length]
          value = instance_variable_get(instance_variable)
          h[key.to_sym] = build_hash_value_from_attribute_value(value)
        end
      end

      private

      def build_hash_value_from_attribute_value(attr_value)
        return attr_value.to_h if known_resource_class?(attr_value.class)
        return attr_value.map(&:to_h) if collection_of_known_resource_class?(attr_value)

        attr_value
      end

      def collection_of_known_resource_class?(object)
        object.is_a?(Array) && object.all? { |item| known_resource_class?(item.class) }
      end

      def known_resource_class?(object_class)
        Sisense.api_resources.value?(object_class)
      end

      def convert_to_obj(hash)
        sanitized_hash(hash).each do |key, value|
          object = build_object(key, value)
          instance_variable_set("@#{key}", object)
          self.class.send(:attr_accessor, key)
        end
      end

      def build_object(key, value)
        return build_resource_collection(key, value) if nested_resource_collection?(key, value)
        return build_resource(key, value) if nested_resource?(key, value)

        value
      end

      def build_resource_collection(key, value)
        resource_collection = value.map { |resource_attributes| build_resource(key, resource_attributes) }
        instance_variable_set("@#{key}", resource_collection)
      end

      def build_resource(key, resource_attributes)
        resource_class(key).new(resource_attributes)
      end

      def nested_resource_collection?(key, value)
        value.is_a?(Array) && value.all? { |obj| nested_resource?(key, obj) }
      end

      def nested_resource?(key, value)
        Sisense.api_resources.key?(key) && value.is_a?(Hash)
      end

      def resource_class(resource)
        Sisense.api_resources[resource]
      end

      def sanitized_hash(hash)
        hash.tap do |h|
          h.keys.each { |key| h[key.underscore] = h.delete(key) }
        end
      end
    end
  end
end
