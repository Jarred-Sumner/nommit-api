class Motd < ActiveRecord::Base
  belongs_to :school

  validates :school, presence: true
  validates :message, presence: true
  validates :expiration, presence: true
  scope :active, -> { where("expiration < ?", DateTime.now).order('created_at DESC') }
end
