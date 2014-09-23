class AddPlaceToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :place, index: true
  end
end
