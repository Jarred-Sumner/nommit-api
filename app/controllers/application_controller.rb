class ApplicationController < ActionController::Base
  attr_writer :current_user
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from Exception, with: :render_generic_error unless Rails.env.development?

  before_action :set_format!, :require_current_user!

  def current_user
    @current_user ||= Session.includes(:user).find_by(token: request.headers['X-SESSION-ID']).try(:user)
  end

  def courier
    @current_courier ||= Courier.find_by(id: params[:courier_id]) if params[:courier_id].present?
  end

  def seller
    @current_seller ||= courier.try(:seller)
  end

  private

    def require_current_user!
      render_error(status: :unauthorized, text: "Oops! It looks like you need to login again :(") if current_user.nil?
    end

    def require_courier!
      render_forbidden unless current_courier.present?
    end

    def render_error(status: nil, text: "An unexpected error occurred")
      status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      render status: status, json: {
        status: status,
        message: text
      }
    end

    def render_invalid_record
      render_error(status: :unprocessable_entity, text: "Oops! It looks like there was an error saving your changes.")
    end

    def render_generic_error(e)
      render_error(status: :internal_server_error, text: "Something broke! Our team has been notified. Try again repeatedly :)")
    end

    def render_not_found
      render_error(status: :not_found, text: "Four Oh Four Error. Not found :'(")
    end

    def render_forbidden
      render_error(status: :forbidden, text: "Oh! You're not allowed to access that. Really sorry.")
    end

    def set_format!
      request.format = :json
    end

end
