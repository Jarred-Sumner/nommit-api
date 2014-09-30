class CreateDeliveryPlaces < ActiveRecord::Migration
  def change
    create_table :delivery_places do |t|
      t.references :shift, index: true
      t.references :place, index: true
      t.datetime :arrives_at
      t.integer :index, null: false
      t.integer :state, null: false, default: 0
      t.integer :start_index, null: false

      t.timestamps
    end
    add_index :delivery_places, :index
  end
end
