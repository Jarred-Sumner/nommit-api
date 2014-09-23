class RenameAddressToLocationOnOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :address_id
    add_reference :orders, :address, index: true
  end
end
