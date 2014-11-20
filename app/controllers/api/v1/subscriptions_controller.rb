class Api::V1::SubscriptionsController < Api::V1::ApplicationController

  def create
    if create_params[:sms].present?
      current_user.subscription ||= Subscription.create!(user_id: current_user.id)
      values = [0, 1]
      state = Integer(create_params[:sms])
      if values.include?(state)
        state = state == 1 ? true : false
        current_user.subscription.update_attributes!(sms: state)
      end
    end

    if create_params[:email].present?
      current_user.subscription ||= Subscription.create!(user_id: current_user.id)
      values = [0, 1]
      state = Integer(create_params[:email])
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

    def create_params
      params.permit(:sms, :email, :user_id)
    end

end
