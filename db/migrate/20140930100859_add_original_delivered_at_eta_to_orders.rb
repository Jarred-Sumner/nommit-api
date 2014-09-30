class AddOriginalDeliveredAtEtaToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :original_delivered_at, :datetime
  end
end
