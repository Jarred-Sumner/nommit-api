class CreateUserPromos < ActiveRecord::Migration
  def change
    create_table :user_promos do |t|
      t.references :user, index: true
      t.references :promo, index: true
      t.integer :amount_remaining_in_cents
      t.integer :state, default: 0, null: false

      t.timestamps
    end
    add_index :user_promos, :state
  end
end
