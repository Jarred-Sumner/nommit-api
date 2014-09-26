class RenameDeliveryLocationsToCourierPlaces < ActiveRecord::Migration
  def change
    rename_table :delivery_locations, :courier_places
  end
end
