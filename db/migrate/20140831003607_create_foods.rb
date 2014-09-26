class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :title
      t.string :place
      t.text :description
      t.integer :price_in_cents
      t.integer :state, default: Food.states[:ready], null: false
      t.datetime :end_date

      t.timestamps
    end
  end
end
