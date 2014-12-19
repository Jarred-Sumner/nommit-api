class AddNotifyToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :notify, :boolean, default: false, null: false
  end
end
