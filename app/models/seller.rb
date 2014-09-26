class Seller < ActiveRecord::Base
  has_attached_file :logo
  has_many :foods

  validates_attachment :logo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
end
