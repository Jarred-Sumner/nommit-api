class AddRatingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :rating, :decimal
  end
end
