class Sms::ArrivalNotificationSender
  include Sidekiq::Worker

  def perform(shift_id)
    shift = Shift.find(shift_id)
    shift.orders.arrived.find_each do |order|
      message = "#{order.user.first_name} -- #{order.user.courier.first_name} is waiting for you at #{order.place.name} to pick up your food."
      Texter.new(message, order.user.phone).perform
    end
  end

end
