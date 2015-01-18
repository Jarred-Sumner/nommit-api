class AddTypeToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :type, :string, default: "BaseFood"
    add_index :foods, :type
    BaseFood.update_all(type: "Food")
  end
end
