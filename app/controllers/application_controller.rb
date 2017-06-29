class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  private

  def authenticate
    if ENV["BASIC_AUTH_NAME"] && ENV["BASIC_AUTH_PASSWORD"]
      authenticate_or_request_with_http_basic do |name, password|
        ActiveSupport::SecurityUtils.variable_size_secure_compare(name, ENV["BASIC_AUTH_NAME"]) &
          ActiveSupport::SecurityUtils.variable_size_secure_compare(password, ENV["BASIC_AUTH_PASSWORD"])
      end
    end
  end
end
