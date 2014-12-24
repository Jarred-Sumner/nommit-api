class Api::V1::ApplicationController < ActionController::Base
  attr_writer :current_user
  include Tracking
  rescue_from Exception, with: :render_generic_error if Rails.env.production?
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::RoutingError, with: :render_not_found

  before_action :set_format!, :require_current_user!

  def current_user
    @current_user ||= Session.includes(:user).find_by(token: request.headers['X-SESSION-ID']).try(:user)
  end

  def courier
    @current_courier ||= current_user.couriers.first
  end

  def seller
    @current_seller ||= courier.try(:seller)
  end

  def school
    @current_school ||= current_user.school
  end

  def apply_promo_to_user!(name: nil)
    promo = Promo.active.find_by!(name: name)
    if promo.class == ReferralPromo && current_user.orders.placed.count > 0
      return render_bad_request("Referral codes are only available for new users")
    elsif promo.user_id == current_user.id
      return render_bad_request("Can't use your own referral code")
    else
      if promo.usable_for?(user: current_user)
        current_user.applied_promos.create!(promo_id: promo.id)
      elsif promo.class == ReferralPromo
        return render_bad_request("Referral codes can only be used once")
      else
        return render_bad_request("Promo code already in use or invalid")
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_bad_request("Promo code not found or expired. Please re-enter it and try again.")
  end

  private

    def platform
      request.headers["X-APP-PLATFORM"]
    end
    helper_method :platform

    def version
      Float(request.headers["X-APP-VERSION"])
    end
    helper_method :version

    def require_current_user!
      render_error(status: :unauthorized, text: "Oops! It looks like you need to login again :(") if current_user.nil?
    end

    def require_courier!
      render_forbidden unless courier.present?
    end

    def require_school!
      render_bad_request("Please choose a school in the account page") if school.nil?
    end

    def render_error(status: nil, text: "An unexpected error occurred")
      status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      render status: status, json: {
        status: status,
        message: text
      }
    end

    def render_bad_request(text = "The information you entered was incorrect, please re-enter it and try again")
      render_error(status: :bad_request, text: text)
    end

    def render_invalid_record(e)
      Bugsnag.notify(e)
      render_error(status: :unprocessable_entity, text: e.record.errors.full_messages.to_sentence)
    end

    def render_generic_error(e)
      raise e if Rails.env.test?
      Bugsnag.notify(e)
      render_error(status: :internal_server_error, text: "Something broke! Our team has been notified. Try again repeatedly :)")
    end

    def render_not_found
      render_error(status: :not_found, text: "Couldn't find the thing you're looking for (404)")
    end

    def render_forbidden
      render_error(status: :forbidden, text: "Oh! You're not allowed to access that. Really sorry.")
    end

    def set_format!
      request.format = :json
    end

end
