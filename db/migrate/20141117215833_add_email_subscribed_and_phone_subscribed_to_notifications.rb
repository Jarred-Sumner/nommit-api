class AddEmailSubscribedAndPhoneSubscribedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :email_subscribed, :boolean, default: true, null: false
    add_column :notifications, :phone_subscribed, :boolean, default: true, null: false
  end
end
