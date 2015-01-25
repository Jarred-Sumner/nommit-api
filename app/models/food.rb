class Food < BaseFood
  belongs_to :parent, class_name: SellableFood
  has_many :orders
  has_many :deliveries
  has_many :shifts, lambda { uniq }, through: :delivery_places
  has_many :delivery_places, through: :deliveries
  has_many :places, lambda { uniq }, through: :delivery_places
  has_many :buyers, through: :orders, source: :user, class_name: User
  has_many :couriers, through: :shifts
  
  accepts_nested_attributes_for :orders
  scope :featured, -> { where(featured: true) }

  include StateID
  enum state: { active: 0, halted: 1, ended: 2 }

  # Foods are visible for awhile
  scope :visible, lambda { where("end_date > ?", 1.day.ago).order("start_date ASC") }

  scope :orderable, -> do
    active
      .where("end_date > ? AND start_date < ?", DateTime.now, DateTime.now)
      .order('start_date ASC')
  end

  scope :notifiable, -> do
    orderable.where(notify: true)
  end

  def orderable?
    active? && end_date.future? && start_date.past? && !sold_out?
  end

  def sold_out?
    orders.placed.count >= goal
  end

  validates :start_date, presence: true
  validates :end_date, presence: true

  def remaining
    goal - sold
  end

  def revenue
    payout_calculator.revenue
  end

  def credit
    orders.completed.sum(:discount_in_cents).to_f / 100.0
  end

  def percent_credit
    if revenue > 0
      (credit / revenue) * 100.0
    else
      0.0
    end
  end

  def payout_calculator
    @payout_calculator ||= PayoutCalculator.new(orders.pluck(:id))
  end

  def payout
    payout_calculator.payout
  end

  def sold
    orders.placed.joins(:price).sum("prices.quantity")
  end

  def rating
    orders.rated.average(:rating).try(:round, 2)
  end

  def customer_satisfaction
    rating = orders.rated.where("rating > 4.5").count.to_f / orders.rated.count.to_f
    rating = rating * 100.0
    rating.round(2)
  end

  def price
    prices.first
  end

  after_commit :notify_users!, if: :notify?, on: :create
  def notify_users!
    Notifications::FoodAvailableWorker.perform_at(start_date + 2.minutes, id)
  end

end
