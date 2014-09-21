class Food < ActiveRecord::Base
  has_attached_file :preview#, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :preview, :content_type => /\Aimage\/.*\Z/
  has_many :orders
  has_and_belongs_to_many :places
  belongs_to :seller

  STATES = {
    active: 1,
    ended: 2
  }

  def active?
    state == STATES[:active]
  end

  scope :active, -> { where(state: STATES[:active]) }
  validates :goal, presence: true
end
