class Api::V1::UsersController < Api::V1::ApplicationController

  def me
  end

  def update
    if current_user.registered?

      if update_params[:confirm_code].present?
        if current_user.confirm_code == Integer(update_params[:confirm_code].to_s)
          current_user.update_attributes!(confirm_code: nil, state: User.states[:activated])
        else
          return render_invalid_confirm_code
        end
      end

      if update_params[:phone].present?
        current_user.update_attributes(phone: update_params[:phone])
        generate_confirm_code!
      end

    end

    if update_params[:stripe_token].present?
      PaymentMethod.create_for(token: update_params[:stripe_token], user: current_user)
    end

    render action: :me
  rescue Stripe::InvalidRequestError, Stripe::CardError => e
    render_bad_request("Couldn't authorize credit card, please re-enter it and try again")
  rescue ArgumentError
    render_invalid_confirm_code
  end

  private

    def update_params
      params.permit(:id, :confirm_code, :stripe_token, :phone, :promo_code)
    end

    def render_invalid_confirm_code
      generate_confirm_code!
      render_bad_request("Invalid confirm code, sending new one. Please enter it and try again.")
    end

    def generate_confirm_code!
      current_user.generate_confirm_code!
      current_user.save!
      Sms::ConfirmCodeSender.perform_async(current_user.id)
    end

end
