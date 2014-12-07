class AddLastNotifiedToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :last_notified, :datetime
  end
end
