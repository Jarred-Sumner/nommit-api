class Subscription < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true, uniqueness: true

  after_commit do
    user.touch
  end

  def push?
    user.devices.count > 0
  end

end
