class RenameAddressesToLocations < ActiveRecord::Migration
  def change
    rename_table :addresses, :locations
  end
end
