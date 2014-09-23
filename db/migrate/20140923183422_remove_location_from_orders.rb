class RemoveLocationFromOrders < ActiveRecord::Migration
  def change
    remove_reference :orders, :location
  end
end
