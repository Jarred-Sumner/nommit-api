tclass Api::V1::PaymentMethodsController < Api::V1::ApplicationController
  before_filter :payment_method_params, only: :show

  def update
    @payment_method = PaymentMethod.create_for(token: payment_method_params[:customer_token], user: current_user)
  end

  def show

  end

  private

    def payment_method_params
      params.permit(:customer_token)
    end

end
