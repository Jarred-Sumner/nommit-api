class User < ActiveRecord::Base
  has_many :orders
  has_many :sessions
  has_many :couriers
  has_many :shifts, through: :couriers
  has_many :applied_promos
  has_many :promos, through: :applied_promos
  has_one :payment_method, -> { where(state: PaymentMethod.states[:active]) }
  has_many :payment_methods
  has_one :referral_promo
  belongs_to :location
  has_many :sellers, through: :couriers
  include StateID

  enum state: [:registered, :activated, :invited]

  attr_accessor :facebook

  def deactivate!
    self.phone = nil
    generate_confirm_code!
    registered!
  end

  def first_name
    self.name.split(" ").first
  end

  def self.from(access_token: nil)
    unless user = Session.includes(:user).find_by(access_token: access_token).try(:user)
      facebook = facebook_for(access_token)
      user = User.where(facebook_uid: facebook['id']).first_or_initialize
      return user if user.persisted?

      user.facebook_uid = facebook['id']
      user.email = facebook['email']
      user.name = facebook['name']
      user.state = 'registered' if user.invited?
      user.save!
    end
    user
  end

  def self.authenticate_or_create!(access_token)
    user = User.from(access_token: access_token)
    Session.create!(user: user, access_token: access_token) if Session.where(access_token: access_token).count.zero?
    user
  end

  def last_ordered
    orders.order("created_at DESC").first.try(:created_at)
  end

  validates :name, presence: true, if: -> { registered? || activated? }
  validates :email, uniqueness: { allow_blank: true }
  validates :facebook_uid, presence: true, uniqueness: true, if: -> { registered? || activated? }

  phony_normalize :phone, default_country_code: 'US'
  validates :phone, phony_plausible: true, uniqueness: true, if: :activated?

  validates :confirm_code, presence: true, uniqueness: true, length: { is: 6 }, if: :registered?

  # TODO
  def referral_credit
  end

  after_create :generate_promo_code!, on: :create
  def generate_promo_code!
    ReferralPromo.create!(user_id: self.id)
  end

  before_validation :generate_confirm_code!, on: :create, if: :registered?
  def generate_confirm_code!
    self.confirm_code = rand(111111..999999)
  end

  # Utility method for retrieving a Facebook object given an access token
  def self.facebook_for(access_token)
    Koala::Facebook::API.new(access_token).get_object("me")
  end
end
