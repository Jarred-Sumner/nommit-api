class AddParentToFoods < ActiveRecord::Migration
  def change
    add_reference :foods, :parent, index: true
  end
end
