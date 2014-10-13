class RemovePromoFromOrder < ActiveRecord::Migration
  def change
    remove_reference :orders, :promo, index: true
  end
end
