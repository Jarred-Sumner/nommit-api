class RenameAddressToLocationOnPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :address_id
    remove_index :places, :address_id
    add_column :places, :address, :reference, index: true
  end
end
