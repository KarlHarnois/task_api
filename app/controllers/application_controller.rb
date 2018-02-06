class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  http_basic_authenticate_with name: Rails.application.secrets.auth_username,
                               password: Rails.application.secrets.auth_password

  def render_422(record)
    render json: { error: record.errors.full_messages.join(', ') }, status: 422
  end
end
