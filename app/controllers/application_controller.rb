# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  include Api::ErrorHandler
end
