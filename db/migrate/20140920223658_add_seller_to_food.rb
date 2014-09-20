class AddSellerToFood < ActiveRecord::Migration
  def change
    add_reference :foods, :seller, index: true
  end
end
