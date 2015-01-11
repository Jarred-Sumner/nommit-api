class OrdersMailer < ApplicationMailer

  def late(order_id)
    @order = Order.find(order_id)
    @user  = @order.user

    discount = number_to_currency(Float(@order.late_discount_in_cents) / 100.0)
    mail to: @user.email, subject: I18n.t("mailers.order.late", discount: discount) 
  end

  def cancelled(order_id)
    @order = Order.find(order_id)
    @user  = @order.user

    mail to: @user.email, subject: I18n.t("mailers.order.cancelled", food: @order.food.title)
  end

end
