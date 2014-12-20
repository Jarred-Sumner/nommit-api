class School < ActiveRecord::Base
  has_many :sellers
  has_many :foods, through: :sellers
  has_many :users
  has_many :places
  has_many :shifts, through: :sellers
  has_many :orders, through: :foods
  has_many :motds

  has_attached_file :image, styles: { normal: "x736" }

  def motd
    motds.active.first
  end

  def revenue
    orders.completed.joins(:charge).where("charges.state = ?", Charge.states[:paid]).sum("charges.amount_charged_in_cents").to_f / 100.0
  end

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
end
