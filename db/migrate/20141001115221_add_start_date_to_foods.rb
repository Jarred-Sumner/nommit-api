class AddStartDateToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :start_date, :datetime
  end
end
