class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :quantity
      t.integer :price_in_cents
      t.references :food, index: true

      t.timestamps
    end
  end
end
