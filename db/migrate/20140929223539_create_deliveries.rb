class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.references :food, index: true
      t.references :delivery_place, index: true

      t.timestamps
    end
  end
end
