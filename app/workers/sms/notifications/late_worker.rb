class SMS::Notifications::LateWorker
  include Sidekiq::Worker
  sidekiq_options queue: :late
  attr_accessor :delivery_place

  def perform(delivery_place_id)
    dp = DeliveryPlace.find(delivery_place_id)
    return false unless dp.late?

    delivery_person = dp.courier.user
    Texter.run "Hurry! You're late to deliver #{dp.orders.pending.count} orders to #{dp.place.name} - that's #{ number_to_currency PayoutCalculator::LATE_FEE } lost per minute of being late.", delivery_person.phone
  end
 
end