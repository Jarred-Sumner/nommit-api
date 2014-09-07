class AddStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :state, :integer, default: 0, null: false
  end
end
