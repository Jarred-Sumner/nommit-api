class Seller < ActiveRecord::Base
  has_attached_file :logo

  validates_attachment :logo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
end
