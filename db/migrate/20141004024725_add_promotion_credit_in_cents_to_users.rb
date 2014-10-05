class AddPromotionCreditInCentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :promotion_credit_in_cents, :integer
  end
end
