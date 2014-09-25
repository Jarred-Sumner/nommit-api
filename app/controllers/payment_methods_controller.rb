class PaymentMethodsController < ApplicationController
  before_filter :payment_method_params, only: :show

  def update
    @payment_method = PaymentMethod.create_from(token: payment_method_params[:customer_token])
  end

  def show

  end

  private

    def payment_method_params
      params.permit(:customer_token)
    end

end
