# frozen_string_literal: true

module Api
  module ErrorHandler
    def self.included(base)
      base.class_eval do
        rescue_from StandardError do |e|
          respond_with_error('unexpected_error', e.message, 500)
        end
        rescue_from ActiveRecord::StatementInvalid, ActiveRecord::QueryCanceled do |_e|
          message = 'Database timeout error'
          respond_with_error('database_timeout', message, 504)
        end
        rescue_from ActiveRecord::RecordNotFound do |e|
          message = "Requested record not found: #{e.model}"
          respond_with_error('record_not_found', message, 404)
        end
      end
    end

    private

    def respond_with_error(code = 'unknown_error', context = {}, http_status = nil, custom_headers = {})
      context = {message: context} if context.is_a?(String)
      context[:code] = code unless context.key?(:code)
      custom_headers.each do |header_name, header_value|
        response.set_header(header_name, header_value)
      end
      render json: context, status: http_status || 500
    end
  end
end
