class User < ActiveRecord::Base
  has_many :orders
  has_one :addresses, as: :addressable

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
    User.where(access_token: access_token).first_or_create!
  rescue Koala::Facebook::AuthenticationError, ActiveRecord::RecordInvalid
  end

  before_validation :update_from_facebook!, on: :create

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :access_token, presence: true
  validates :facebook_uid, presence: true, uniqueness: true
end
