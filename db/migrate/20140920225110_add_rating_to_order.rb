class AddRatingToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :rating, :integer
  end
end
