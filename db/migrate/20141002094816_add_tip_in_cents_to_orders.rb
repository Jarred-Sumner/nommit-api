class AddTipInCentsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tip_in_cents, :integer
  end
end
