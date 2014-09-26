class CourierPlace < ActiveRecord::Base
  belongs_to :courier
  belongs_to :place
end
