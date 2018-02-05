class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404(error)
    render json: { error: { message: error.message } }, status: :not_found
  end

  def render_422(record)
    render json: { error: { message: record.errors.full_messages.first } }, status: 422
  end
end
