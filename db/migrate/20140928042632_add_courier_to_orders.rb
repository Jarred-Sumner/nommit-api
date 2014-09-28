class AddCourierToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :courier, index: true
  end
end
