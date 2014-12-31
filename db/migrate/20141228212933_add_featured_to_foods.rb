class AddFeaturedToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :featured, :boolean, default: false, null: false
    add_index :foods, :featured
  end
end
