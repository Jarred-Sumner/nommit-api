class AddDeliveredAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivered_at, :datetime
  end
end
