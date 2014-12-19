class AddSchoolToSellers < ActiveRecord::Migration
  def change
    add_reference :sellers, :school, index: true
  end
end
