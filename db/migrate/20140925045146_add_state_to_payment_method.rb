class AddStateToPaymentMethod < ActiveRecord::Migration
  def change
    add_column :payment_methods, :state, :integer, default: 0, null: false
  end
end
