class CreateFoodDeliveryPlaces < ActiveRecord::Migration
  def change
    create_table :food_delivery_places do |t|
      t.references :food, index: true
      t.references :place, index: true
      t.references :courier, index: true
      t.references :seller, index: true
      t.integer :index
      t.integer :wait_interval
      t.integer :state, default: 0, null: false

      t.timestamps
    end
  end
end
