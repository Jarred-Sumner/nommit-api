class User < ActiveRecord::Base
  has_many :orders
  has_many :sessions
  has_many :couriers
  has_many :shifts, through: :couriers
  has_many :user_promos
  has_one :promo
  has_one :payment_method, -> { where(state: PaymentMethod.states[:active]) }
  belongs_to :location
  has_many :sellers, through: :couriers
  include StateID

  enum state: [:registered, :activated]

  attr_accessor :facebook

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

  def self.facebook_for(access_token)
    Koala::Facebook::API.new(access_token).get_object("me")
  end
end
