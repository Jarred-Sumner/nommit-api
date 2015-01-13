class SMS::Notifications::LateWorker
  include Sidekiq::Worker
  include ActionView::Helpers::NumberHelper
  sidekiq_options queue: :late
  attr_accessor :delivery_place

  def perform(delivery_place_id)
    self.delivery_place ||= DeliveryPlace.find(delivery_place_id)
    return false unless delivery_place.late?

    delivery_person = delivery_place.courier.user
    Texter.run "Hurry! You're late to deliver #{delivery_place.orders.pending.count} orders to #{delivery_place.place.name} - that's #{ number_to_currency PayoutCalculator::LATE_FEE } lost per minute of being late.", delivery_person.phone
  end
 
end