class Food < ActiveRecord::Base
  has_many :orders
  
end
