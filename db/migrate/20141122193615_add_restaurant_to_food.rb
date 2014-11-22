class AddRestaurantToFood < ActiveRecord::Migration
  def change
    add_reference :foods, :restaurant, index: true
  end
end
