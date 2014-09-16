class Session < ActiveRecord::Base
  belongs_to :user

  before_validation :generate_token!, on: :create
  validates :token, presence: true, uniqueness: true

  def generate_token!
    self.token = SecureRandom.urlsafe_base64(16)
  end
  
end
