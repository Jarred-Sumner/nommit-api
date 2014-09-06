class AddGoalToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :goal, :integer
  end
end
