class SellableFood < BaseFood
  has_many :versions, class_name: Food, foreign_key: "parent_id"
end