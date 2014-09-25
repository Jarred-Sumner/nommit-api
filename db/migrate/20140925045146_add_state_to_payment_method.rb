class AddStateToPaymentMethod < ActiveRecord::Migration
  def change
    add_column :payment_methods, :state_id, :integer
  end
end
