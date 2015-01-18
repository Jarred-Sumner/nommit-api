class BaseFood < ActiveRecord::Base
  self.table_name = "foods"

  has_attached_file :preview, styles: { normal: "150x736" }
  validates_attachment_content_type :preview, :content_type => /\Aimage\/.*\Z/

  belongs_to :seller
  belongs_to :restaurant
  has_one :school, through: :seller
  has_many :prices, foreign_key: "food_id"

  has_many :buyers, through: :orders, source: :user, class_name: User
  accepts_nested_attributes_for :prices

  validates :title, presence: true
  validates :description, presence: true
  validates :goal, presence: true
  validates :seller_id, presence: true
  has_many :foods, foreign_key: "parent_id"

  def set_prices!(prices)
    transaction do
      self.prices.destroy_all

      default_price = prices[0]
      9.times do |index|
        price = prices[index] || default_price * (index + 1)
        self.prices.create!(quantity: index + 1, price_in_cents: price)
      end

    end
  end

end