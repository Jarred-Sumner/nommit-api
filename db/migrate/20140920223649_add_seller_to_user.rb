class AddSellerToUser < ActiveRecord::Migration
  def change
    add_reference :users, :seller, index: true
  end
end
