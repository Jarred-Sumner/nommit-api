class Sms::Notifications::ArrivalWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(shift_id)
    shift = Shift.find(shift_id)
    shift.orders.arrived.find_each do |order|
      deliver_message!(order)
    end
  end

  def deliver_message!(order)
    user = order.user
    courier_user = order.courier.user
    message = "#{user.first_name}, #{courier_user.first_name} is waiting for you at the front door of #{order.place.name} to pick up your food."
    Texter.run(message, order.user.phone)
  end

end
