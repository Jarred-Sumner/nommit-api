class AddShiftToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :shift, index: true
    Order.find_each do |order|
      order.update_attributes!(shift_id: order.delivery_place.shift_id)
    end
  end
end
