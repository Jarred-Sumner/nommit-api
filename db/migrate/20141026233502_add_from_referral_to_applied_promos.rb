class AddFromReferralToAppliedPromos < ActiveRecord::Migration
  def change
    add_column :applied_promos, :from_referral, :boolean
  end
end
