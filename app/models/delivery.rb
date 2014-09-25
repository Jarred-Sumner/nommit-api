class Delivery < ActiveRecord::Base
  belongs_to :courier
  belongs_to :order
end
