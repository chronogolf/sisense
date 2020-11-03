require "net/http"
require "uri"
require "cgi"
require "json"
require "erb"

module Sisense
  module API
    class Client
      include ERB::Util

      PATH_SEGMENT_PATTERN = %r{[^/]+}.freeze

      VERB_MAP = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        patch: Net::HTTP::Patch,
        delete: Net::HTTP::Delete
      }.freeze

      def initialize
        uri = URI.parse(base_uri)
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.use_ssl = Sisense.use_ssl
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
          response_hash
            .select { |obj| obj.is_a?(Hash) }
            .map { |json_item| object_class.new(json_item) }
        else
          object_class.new(response_hash)
        end
      end

      private

      def base_uri
        @base_uri ||= Sisense.use_ssl ? "https://#{Sisense.hostname}" : "http://#{Sisense.hostname}"
      end

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
        handle_response(http.request(request))
      end

      def handle_response(response)
        return response if %w[200 201 204].include?(response.code)

        handle_error(response)
      end

      def handle_error(response)
        error_params = JSON.parse(response.body, symbolize_names: true)
        new_api_format_error_params = error_params[:error]
        error_params = new_api_format_error_params || error_params
        case response.code
        when "404"
          raise Sisense::API::NotFoundError, error_params
        when "422"
          raise Sisense::API::UnprocessableEntityError, error_params
        else
          raise Sisense::API::Error, error_params
        end
      end

      def encode_path_segments(path)
        path.gsub PATH_SEGMENT_PATTERN do |segment|
          url_encode(segment)
        end
      end

      def encode_path(path, params = nil)
        encoded_path = encode_path_segments(path)
        return encoded_path if params.nil?

        encoded_params = URI.encode_www_form(params)
        uri = URI::HTTP.build(path: encoded_path, query: encoded_params)
        uri.request_uri
      end

      def headers
        @headers ||= {"Authorization" => "Bearer #{Sisense.access_token}", "Content-Type" => "application/json"}
      end

      def parameterize(object)
        object.tap do |obj|
          return object.map { |item| parameterize(item) } if object.is_a?(Array)

          obj.keys.each do |key|
            obj[key] = parameterize_object(obj[key])
            obj[key.to_s.to_camel_case] = obj.delete(key)
          end
        end
      end

      def parameterize_object(object)
        return parameterize(object.to_h) if Sisense::API::Resource.descendants.include?(object.class)
        return parameterize(object) if object.is_a?(Hash)
        return object.map { |item| item.is_a?(String) ? item : parameterize_object(item) } if object.is_a?(Array)

        object
      end
    end
  end
end
