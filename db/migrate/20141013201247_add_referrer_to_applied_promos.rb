class AddReferrerToAppliedPromos < ActiveRecord::Migration
  def change
    add_reference :applied_promos, :referrer, index: true
  end
end
