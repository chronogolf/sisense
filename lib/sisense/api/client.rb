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
          response_hash.map { |json_item| object_class.new(json_item) }
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
          request.body = params.to_json
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
        when '404'
          raise Sisense::API::NotFoundError, error_params
        when '422'
          raise Sisense::API::UnprocessableEntityError, error_params
        else
          raise Sisense::API::Error, error_params
        end
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
    end
  end
end
