class Api::V1::SubscriptionsController < Api::V1::ApplicationController

  def create
    if update_params[:sms].present?
      current_user.subscription ||= Subscription.create!(user_id: current_user.id)
      values = [0, 1]
      state = Integer(update_params[:sms])
      if values.include?(state)
        state = state == 1 ? true : false
        current_user.subscription.update_attributes!(sms: state)
      end
    end

    if update_params[:email].present?
      current_user.subscription ||= Subscription.create!(user_id: current_user.id)
      values = [0, 1]
      state = Integer(update_params[:email])
      if values.include?(state)
        state = state == 1 ? true : false
        current_user.subscription.update_attributes!(email: state)
      end
    end

    render action: :show
  end

  def show
  end

  private

    def subscription
      current_user.subscription
    end

    def update_params
      params.permit(:sms, :email, :user_id)
    end

end
