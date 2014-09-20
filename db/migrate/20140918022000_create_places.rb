class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.boolean :enabled
      t.references :address, index: true

      t.timestamps
    end
  end
end
