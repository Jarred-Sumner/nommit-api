class Api::V1::SubscriptionsController < Api::V1::ApplicationController

  def create
    if create_params[:sms].present?
      values = [0, 1]
      state = Integer(create_params[:sms])
      if values.include?(state)
        state = state == 1 ? true : false
        subscription.update_attributes!(sms: state)
      end
    end

    if create_params[:email].present?
      values = [0, 1]
      state = Integer(create_params[:email])
      if values.include?(state)
        state = state == 1 ? true : false
        subscription.update_attributes!(email: state)
      end
    end

    if create_params[:push_notifications].present?
      values = [0, 1]
      state = Integer(create_params[:push_notifications])
      if values.include?(state)
        state = state == 1 ? true : false
        if !state
          current_user.devices.registered.update_all(registered: false)
        end
      end
    end

    render subscription
  end

  def show
    render subscription
  end

  private

    def subscription
      @subscription ||= current_user.subscription ||= Subscription.create!(user_id: current_user.id)
    end

    def create_params
      params.permit(:sms, :email, :push_notifications, :user_id)
    end

end
