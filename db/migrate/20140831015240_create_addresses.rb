class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :phone
      t.string :address_one
      t.string :address_two
      t.string :city, default: "Pittsburgh"
      t.string :state, default: "PA"
      t.string :zip, default: "15213"
      t.string :country, default: "United States"
      t.integer :addressable_id
      t.string :addressable_type

      t.text :instructions
      t.timestamps
    end

    add_index :addresses, :addressable_id
    add_index :addresses, :addressable_type
  end
end
