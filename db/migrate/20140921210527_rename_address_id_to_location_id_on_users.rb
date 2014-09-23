class RenameAddressIdToLocationIdOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :address_id, :location_id
  end
end
