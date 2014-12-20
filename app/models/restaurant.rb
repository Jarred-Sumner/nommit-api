class Restaurant < ActiveRecord::Base
  has_many :foods
  has_many :sellers, through: :foods
  has_attached_file :logo, styles: { normal: "180x180" }

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :name, presence: true
end
