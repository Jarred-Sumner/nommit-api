class AddLatitudeAndLongitudeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :latitude, :decimal
    add_column :locations, :longitude, :decimal

    add_index :locations, :latitude
    add_index :locations, :longitude
  end
end
