class AddSchoolToPlaces < ActiveRecord::Migration
  def change
    add_reference :places, :school, index: true
  end
end
