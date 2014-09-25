class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :name, :null => false, :unique => true
      t.integer :discount_in_cents, :null => false, :default => 500
      t.datetime :expiration
      t.references :user, index: true

      t.timestamps
    end
    add_index :promos, :name, :unique => true
  end
end
