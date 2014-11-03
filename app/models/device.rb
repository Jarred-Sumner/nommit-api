class Device < ActiveRecord::Base
  belongs_to :user
  enum :platform => [:ios, :android]
  scope :registered, -> { where(registered: true) }

  validate :platform, presence: true
  validate :user, presence: true
  validate :token, presence: true, uniqueness: true

  def device_token
    "<" + Base64.decode64(token).unpack('H*').first.scan(/\w{8}/).join(' ') + ">"
  end
end
