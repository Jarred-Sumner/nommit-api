class Delivery < ActiveRecord::Base
  belongs_to :courier
  belongs_to :order

  def user
    courier.try(:user)
  end
end
