class AddPromoToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :promo, index: true
  end
end
