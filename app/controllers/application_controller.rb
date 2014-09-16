class ApplicationController < ActionController::Base
  attr_writer :current_user

  before_action :set_format!, :require_current_user!

  def current_user
    @current_user ||= Session.includes(:user).find_by(token: request.headers['X-SESSION-ID']).try(:user)
  end

  private

    def render_error(status: nil, text: "An unexpected error occurred")
      render status: status, json: {
        message: text
      }
    end

    def require_current_user!
      render status: :unauthorized if current_user.nil?
    end

    def set_format!
      request.format = :json
    end

end
