class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.time :from_hours
      t.time :to_hours

      t.timestamps
    end
  end
end
