class User < ActiveRecord::Base
  has_many :orders
  belongs_to :address

  attr_accessor :facebook

  def self.from(access_token: nil)
    unless user = User.find_by(access_token: access_token)
      facebook = Koala::Facebook::API.new(access_token).get_object("me")
      user = User.where(facebook_uid: facebook['id']).first_or_initialize
      return user if user.persisted?

      user.facebook_uid = facebook['id']
      user.email = facebook['email']
      user.name = facebook['name']
      user.save!
    end
    user
  end

  def self.authenticate_or_create!(access_token)
    user = User.from(access_token: access_token)
    user.update_attributes!(last_signin: DateTime.now, access_token: access_token)
    user
  end

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :facebook_uid, presence: true, uniqueness: true
end
