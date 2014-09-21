class RenameAddressToLocationOnOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :address_id
    remove_index :orders, :address_id
    add_column :orders, :address, :reference, index: true
  end
end
