class AddDiscountInCentsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :discount_in_cents, :integer, default: 0, null: false
  end
end
