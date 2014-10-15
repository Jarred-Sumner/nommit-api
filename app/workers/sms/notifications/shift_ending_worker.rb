class Sms::Notifications::ShiftEndingWorker
  include Sidekiq::Worker

  def perform(shift_id)
    shift = Shift.find(shift_id)
    Courier
      .where(seller_id: shift.seller_id)
      .where.not(id: shift.courier_id)
      .each do |courier|
        message = "#{shift.courier.user.first_name}'s shift ended! No more orders to #{shift.delivery_places.count} places until someone else delivers to those places."
        Texter.run(message, courier.user.phone)
      end
  end
end
