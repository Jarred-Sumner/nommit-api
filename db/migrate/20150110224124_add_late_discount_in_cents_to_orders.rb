class AddLateDiscountInCentsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :late_discount_in_cents, :integer, default: 0
  end
end
