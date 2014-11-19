class Notifications::FoodAvailableWorker
  include Sidekiq::Worker
  attr_accessor :food
  sidekiq_options retry: false
  TEXT_THRESHOLD = 1 unless defined?(TEXT_THRESHOLD)

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
    notification = user.notification || Notification.new(user_id: user.id)


    # If they haven't ordered in TEXT_THRESHOLD weeks
    if user.phone.present? && notification.phone_subscribed?
      ordered_awhile_ago = user.orders.placed.where("created_at < ?", TEXT_THRESHOLD.weeks.ago).count > 0
      ordered_recently = user.orders.placed.where("created_at > ?", TEXT_THRESHOLD.weeks.ago).count > 0

      # If they haven't ordered recently but have ordered in the past
      # Or, they just never ordered
      if (ordered_awhile_ago && !ordered_recently) || user.orders.placed.count.zero?

        # If we've never texted them
        # OR If we haven't texted them in over a week
        if notification.last_texted.nil? || notification.last_texted < TEXT_THRESHOLD.weeks.ago
          send_text!(user.id)
          notification.last_texted = DateTime.now
        end

      end
    end

    if user.email.present? && notification.email_subscribed?
      send_email!(user.id)
      notification.last_emailed = DateTime.now
    end

    send_push_notification!(user.id) if user.devices.registered.count > 0

    notification.save!
  rescue Exception => e
    Bugsnag.notify(e)
    Rails.logger.info "Exception while notifying: #{e.inspect}"
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
