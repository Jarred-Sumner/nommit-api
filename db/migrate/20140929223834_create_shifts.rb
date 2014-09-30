class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.references :courier, index: true
      t.references :seller, index: true
      t.integer :state, default: 0, null: false

      t.timestamps
    end
    add_index :shifts, :state
  end
end
