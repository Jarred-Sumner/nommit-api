class DeliveryLocation < ActiveRecord::Base
  belongs_to :courier
  belongs_to :place
end
