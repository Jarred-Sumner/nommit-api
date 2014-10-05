class CreateOrdersUserPromos < ActiveRecord::Migration
  def change
    create_table :orders_user_promos do |t|
      t.references :user_promo, index: true
      t.references :order, index: true
    end
  end
end
