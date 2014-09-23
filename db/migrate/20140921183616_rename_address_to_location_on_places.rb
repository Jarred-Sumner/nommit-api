class RenameAddressToLocationOnPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :address_id, :location_id
  end
end
