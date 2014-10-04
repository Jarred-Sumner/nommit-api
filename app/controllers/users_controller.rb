class UsersController < ApplicationController

  def me
  end

  def update
    if current_user.registered?

      if update_params[:confirm_code].present?
        if current_user.confirm_code == update_params[:confirm_code]
          current_user.update_attributes!(confirm_code: nil, state: User.states[:activated])
        else
          return render_bad_request("Invalid confirm code, sending new one to #{Phony.format(current_user.phone)}. Please enter it and try again.")
        end
      end

      if update_params[:phone].present?
        current_user.phone = update_params[:phone]
        current_user.generate_confirm_code!
        current_user.save!
      end

    end

    if update_params[:stripe_token].present?
      PaymentMethod.create_for(token: update_params[:stripe_token], user: current_user)
    end

    if update_params[:promo_code].present?

    end

    render action: :me
  rescue Stripe::InvalidRequestError, Stripe::CardError => e
    render_bad_request("Couldn't authorize credit card, please re-enter it and try again")
  end

  private

    def update_params
      params.permit(:id, :confirm_code, :stripe_token, :phone, :promo_code)
    end

end
