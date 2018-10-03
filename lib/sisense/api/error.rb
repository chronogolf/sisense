module Sisense
  module API
    class Error < StandardError
      attr_reader :code, :message, :status, :http_message

      def initialize(**error_params)
        @code = error_params[:code]
        @message = error_params[:message]
        @status = error_params[:status]
        @http_message = error_params[:http_message]
      end
    end
  end
end
