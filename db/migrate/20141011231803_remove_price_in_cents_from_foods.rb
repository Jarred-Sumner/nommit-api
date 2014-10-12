class RemovePriceInCentsFromFoods < ActiveRecord::Migration
  def change
    remove_column :foods, :price_in_cents, :integer
  end
end
