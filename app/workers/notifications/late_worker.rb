class Notifications::LateWorker
  include Sidekiq::Worker
  sidekiq_options queue: :late
  attr_accessor :dp

  def perform(delivery_place_id)
    self.dp ||= DeliveryPlace.find(delivery_place_id)
    if dp.late?

      if delivery_person.subscription.push?
        PushNotifications::Courier::LateWorker.perform_async(dp.id)
      elsif delivery_person.subscription.sms?
        SMS::Notifications::LateWorker.perform_async(dp.id)
      end

    elsif dp.active?
      Notifications::LateWorker.perform_at(dp.arrives_at + 30.seconds, dp.id)
    end

  end

  def delivery_person
    @delivery_person ||= dp.courier.user
  end

end