require 'net/http'
require 'uri'
require 'json'

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
            request = VERB_MAP[method].new(encode_path(path, params), headers)
          else
            request = VERB_MAP[method].new(encode_path(path), headers)
            request.set_form_data(params)
          end
          http.request(request)
        end

        def encode_path(path, params = nil)
          encoded_path = URI::encode(path)
          return path if params.nil?
          encoded_params = URI.encode_www_form(params)
          [encoded_path, encoded_params].join('?')
        end

        def headers
          @headers ||= { 'Authorization' => "Bearer #{Sisense.access_token}" }
        end
    end
  end
end
