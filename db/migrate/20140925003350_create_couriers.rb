class CreateCouriers < ActiveRecord::Migration
  def change
    create_table :couriers do |t|
      t.references :user, index: true
      t.references :seller, index: true
      t.integer :state_id, default: 0, null: false

      t.timestamps
    end
  end
end
