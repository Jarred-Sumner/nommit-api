class CreateFoodsPlaces < ActiveRecord::Migration
  def change
    create_table :foods_places do |t|
      t.references :food, index: true
      t.references :place, index: true
    end
  end
end
