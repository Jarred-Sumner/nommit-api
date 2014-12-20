class CreateMotds < ActiveRecord::Migration
  def change
    create_table :motds do |t|
      t.string :message
      t.datetime :expiration
      t.references :school, index: true

      t.timestamps
    end
  end
end
