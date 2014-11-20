class Api::V1::UsersController < Api::V1::ApplicationController

  def me
  end

  def update
    if current_user.registered? || current_user.invited?

      if update_params[:confirm_code].present?
        if current_user.confirm_code == Integer(update_params[:confirm_code].to_s)
          current_user.update_attributes!(confirm_code: nil, state: User.states[:activated])
          track_activation
        else
          return render_invalid_confirm_code
        end
      elsif update_params[:phone].present?
        phone = PhonyRails.normalize_number(update_params[:phone], default_country_code: "US")
        raise Phony::NormalizationError unless Phony.plausible?(phone)

        ActiveRecord::Base.transaction do
          if old_user = User.invited.find_by(phone: phone)
            old_user.destroy
          end
          current_user.update_attributes(phone: phone)
        end
        generate_confirm_code!
      else
        return render_bad_request("To continue, please enter a phone number.")
      end

    end

    if update_params[:stripe_token].present?
      begin
        PaymentMethod.create_for(token: update_params[:stripe_token], user: current_user)
        track_update_payment_method
      rescue Stripe::InvalidRequestError, Stripe::CardError, ArgumentError => e
        return render_bad_request("Couldn't validate credit card, please re-enter it and try again")
      end
    end

    if update_params[:push_notifications] == "reset"
      current_user.devices.update_all(last_notified: nil)
    end

    render action: :me
  rescue ArgumentError
    render_invalid_confirm_code
  rescue Phony::NormalizationError
    render_bad_request("Please enter a valid phone number")
  end

  private

    def update_params
      params.permit(:id, :confirm_code, :stripe_token, :phone, :promo_code, :push_notifications)
    end

    def render_invalid_confirm_code
      generate_confirm_code!
      render_bad_request("Invalid confirm code, sending new one. Please enter it and try again.")
    end

    def generate_confirm_code!
      Sms::ConfirmCodeSender.perform_async(current_user.id)
      track_sent_confirm_code
    end

end
