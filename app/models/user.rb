class User < ActiveRecord::Base
  has_many :orders
  has_many :sessions
  has_many :couriers
  has_many :shifts, through: :couriers
  has_one :promo
  has_one :payment_method
  belongs_to :location
  has_many :sellers, through: :couriers

  attr_accessor :facebook

  def self.from(access_token: nil)
    unless user = Session.includes(:user).find_by(access_token: access_token).try(:user)
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
    Session.create!(user: user, access_token: access_token) if Session.where(access_token: access_token).count.zero?
    user
  end

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :facebook_uid, presence: true, uniqueness: true

  # TODO
  def referral_credit
  end

  after_commit :generate_promo_code!, on: :create
  def generate_promo_code!
    ReferralPromo.create!(user_id: self.id)
  end

end
