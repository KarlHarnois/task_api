class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  http_basic_authenticate_with name: Rails.application.secrets.auth_username,
                               password: Rails.application.secrets.auth_password

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404(error)
    render json: { error: { message: error.message } }, status: :not_found
  end

  def render_422(record)
    render json: { error: { message: record.errors.full_messages.first } }, status: 422
  end
end
