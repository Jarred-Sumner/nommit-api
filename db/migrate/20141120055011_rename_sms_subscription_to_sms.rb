class RenameSmsSubscriptionToSms < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :phone_subscribed, :sms
  end
end
