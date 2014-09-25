class RenameStateIdToStateInCouriers < ActiveRecord::Migration
  def change
    rename_column :couriers, :state_id, :state
  end
end
