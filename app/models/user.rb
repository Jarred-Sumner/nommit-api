class User < ActiveRecord::Base
  has_many :orders
  belongs_to :address

  def update_from_facebook!
    facebook = Koala::Facebook::API.new(access_token)
    user = facebook.get_object("me")

    self.facebook_uid = user['id']
    self.email = user['email']
    self.name = user['name']
  rescue Koala::Facebook::AuthenticationError
    errors.add(:access_token, "is unauthorized")
  end

  def self.authenticate_or_create!(access_token)
    user = User.where(access_token: access_token).first_or_create!
    user.touch(:last_signin)
    user
  end

  before_validation :update_from_facebook!, on: :create

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :access_token, presence: true
  validates :facebook_uid, presence: true, uniqueness: true
end
