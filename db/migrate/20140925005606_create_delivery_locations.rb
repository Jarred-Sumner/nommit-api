class CreateDeliveryLocations < ActiveRecord::Migration
  def change
    create_table :delivery_locations do |t|
      t.datetime :arrives_at
      t.references :courier, index: true
      t.integer :offset
      t.references :place, index: true

      t.timestamps
    end
  end
end
