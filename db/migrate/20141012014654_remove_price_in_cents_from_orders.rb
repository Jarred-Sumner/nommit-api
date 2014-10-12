class RemovePriceInCentsFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :price_in_cents, :integer
  end
end
