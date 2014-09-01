class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :food, index: true
      t.references :user, index: true
      t.integer :state, :default => 0, :null => false
      t.integer :quantity, :default => 1, :null => false
      t.integer :price_in_cents, :null => false

      t.timestamps
    end
  end
end
