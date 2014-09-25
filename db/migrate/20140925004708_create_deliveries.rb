class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.references :courier, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
