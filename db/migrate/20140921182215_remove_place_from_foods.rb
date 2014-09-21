class RemovePlaceFromFoods < ActiveRecord::Migration
  def change
    remove_column :foods, :place, :string
  end
end
