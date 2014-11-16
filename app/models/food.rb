class Food < ActiveRecord::Base
  has_attached_file :preview#, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :preview, :content_type => /\Aimage\/.*\Z/
  has_many :orders
  has_many :deliveries
  has_many :shifts, through: :seller
  has_many :delivery_places, through: :deliveries
  has_many :places, lambda { uniq }, through: :delivery_places
  has_many :couriers, through: :shifts
  belongs_to :seller
  has_many :prices

  include StateID
  enum state: { active: 0, halted: 1, ended: 2 }

  # Foods are visible for awhile.
  scope :visible, lambda { where("end_date > ?", 1.day.ago) }

  scope :orderable, -> do
    active.visible
  end

  def orderable?
    active? && end_date.future? && start_date.past? && !sold_out?
  end

  def sold_out?
    orders.placed.count >= goal
  end

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

  def ended!
    update_attributes!(state: 'ended')
    PushNotifications::FoodUnavailableWorker.perform_async(id)
  end

  validates :title, presence: true
  validates :description, presence: true
  validates :goal, presence: true
  validates :seller_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def remaining
    self.goal - sold
  end

  def sold
    orders.placed.joins(:price).sum("prices.quantity")
  end

  def rating
    orders.rated.average(:rating)
  end

  after_commit :notify_users!, :send_end_food!, on: :create

  def send_end_food!
    PushNotifications::FoodUnavailableWorker.perform_at(end_date + 5.seconds, id)
  end

  def notify_users!
    Notifications::FoodAvailableWorker.perform_at(start_date, id)
  end

end
