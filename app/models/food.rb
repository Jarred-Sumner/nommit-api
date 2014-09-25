class Food < ActiveRecord::Base
  has_attached_file :preview#, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :preview, :content_type => /\Aimage\/.*\Z/
  has_many :orders
  has_and_belongs_to_many :places
  belongs_to :seller

  include StateID
  enum state: { active: 1, ended: 2 }
  validates :goal, presence: true
end
