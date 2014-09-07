class AddAddressToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :address, index: true
  end
end
