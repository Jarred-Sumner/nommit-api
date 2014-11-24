class Notifications::FoodAvailableWorker
  include Sidekiq::Worker
  attr_accessor :food
  sidekiq_options retry: false

  def perform(food_id)
    self.food = Food.orderable.find(food_id)

    if food.orderable?
      User.where(state: [ User.states[:registered], User.states[:activated] ]).find_each do |user|
        notify_user!(user)
      end
    elsif food.start_date.future?
      Notifications::FoodAvailableWorker.perform_at(food.start_date + 2.minutes, food.id)
    end
  end

  def notify_user!(user)
    user.subscription ||= Subscription.new(user_id: user.id, sms: true, email: true)

    if should_push?(user)
      send_push_notification!(user.id)
    elsif should_email?(user)
      send_email!(user.id)
      user.subscription.last_emailed = DateTime.now
    end

    user.subscription.save!
  rescue Exception => e
    Bugsnag.notify(e)
    Rails.logger.info "Exception while notifying: #{e.inspect}"
  end

  def should_text?(user)
    # TODO: texting is disabled.
    return false

    return false if user.phone.blank?
    return false unless user.subscription.sms?
    true
  end

  def should_email?(user)
    user.email.present? && user.subscription.email?
  end

  def should_push?(user)
    user.devices.registered.count > 0
  end

  def send_text!(user_id)
    SMS::Notifications::FoodAvailableWorker.perform_async(user_id, food.id)
  end

  def send_email!(user_id)
    FoodsMailer.delay.new(food.id, user_id)
  end

  def send_push_notification!(user_id)
    PushNotifications::FoodAvailableWorker.perform_async(food.id, user_id)
  end

end
