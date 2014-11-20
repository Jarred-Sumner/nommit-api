class RenameEmailSubscriptionToEmail < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :email_subscribed, :email
  end
end
