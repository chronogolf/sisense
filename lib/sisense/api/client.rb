require 'net/http'
require 'uri'
require 'cgi'
require 'json'

module Sisense
  module API
    class Client
      VERB_MAP = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        patch: Net::HTTP::Patch,
        delete: Net::HTTP::Delete
      }.freeze

      def initialize
        uri = URI.parse(Sisense.base_uri)
        @http = Net::HTTP.new(uri.host, uri.port)
      end

      attr_reader :http

      def get(path, params: {})
        request :get, path, params
      end

      def post(path, params: {})
        request :post, path, params
      end

      def put(path, params: {})
        request :put, path, params
      end

      def patch(path, params: {})
        request :patch, path, params
      end

      def delete(path)
        request :delete, path
      end

      def parsed_response(response, object_class:)
        response_hash = JSON.parse(response.body)
        if collection?(response_hash)
          response_hash.map { |json_item| object_class.new(json_item) }
        else
          object_class.new(response_hash)
        end
      end

      private

      def collection?(response_body)
        response_body.is_a?(Array)
      end

      def request(method, path, params = {})
        case method
        when :get
          request = VERB_MAP[method].new(encode_path(path, params), headers)
        else
          request = VERB_MAP[method].new(encode_path(path), headers)
          request.body = parameterize(params).to_json
        end
        http.request(request)
      end

      def encode_path(path, params = nil)
        encoded_path = URI.encode(path)
        return path if params.nil?

        encoded_params = URI.encode_www_form(params)
        [encoded_path, encoded_params].join('?')
      end

      def headers
        @headers ||= { 'Authorization' => "Bearer #{Sisense.access_token}", 'Content-Type' => 'application/json' }
      end

      def parameterize(object)
        object.tap do |obj|
          return object.map { |item| parameterize(item) } if object.is_a?(Array)

          obj.keys.each do |key|
            obj[key] = parameterize_object(obj[key]) unless obj[key].is_a?(String)
            obj[key.to_s.to_camel_case] = obj.delete(key)
          end
        end
      end

      def parameterize_object(object)
        return parameterize(object.to_h) if Sisense::API::Resource.descendants.include?(object.class)
        return parameterize(object) if object.is_a?(Hash)
        return object.map { |item| item.is_a?(String) ? item : parameterize_object(item) } if object.is_a?(Array)
      end
    end
  end
end
