class AddEndedAtToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :ended_at, :datetime
  end
end
