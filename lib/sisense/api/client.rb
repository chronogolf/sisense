require 'net/http'
require 'uri'
require 'json'

Dir[File.join(__dir__, 'endpoints', '*.rb')].each { |file| require file }

module Sisense
  module API
    class Client
      VERB_MAP = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
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

      def delete(path, params: {})
        request :delete, path, params
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

        def request(method, path, params)
          case method
          when :get
            path_with_params = encode_path_params(path, params)
            request = VERB_MAP[method].new(path_with_params, headers)
          else
            request = VERB_MAP[method].new(path, headers)
            request.set_form_data(params)
          end
          http.request(request)
        end

        def encode_path_params(path, params)
          encoded = URI.encode_www_form(params)
          [path, encoded].join('?')
        end

        def headers
          @headers ||= { 'Authorization' => "Bearer #{Sisense.access_token}" }
        end
    end
  end
end
