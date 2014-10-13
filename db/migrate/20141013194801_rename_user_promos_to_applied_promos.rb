class RenameUserPromosToAppliedPromos < ActiveRecord::Migration
  def change
    rename_table :user_promos, :applied_promos
    rename_table :orders_user_promos, :applied_promos_orders
    rename_column :applied_promos_orders, :user_promo_id, :applied_promo_id
  end
end
