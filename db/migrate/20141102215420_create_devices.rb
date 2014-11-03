class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.text :token, null: false
      t.boolean :registered, default: false, null: false
      t.datetime :last_notified
      t.references :user, index: true
      t.integer :platform, null: false

      t.timestamps
    end
  end
end
