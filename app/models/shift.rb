class Shift < ActiveRecord::Base
  belongs_to :courier
  belongs_to :seller
  has_many :delivery_places
  has_many :foods, lambda { uniq }, through: :delivery_places
  LONGEST_DELIVER_TIME = 15.0 unless defined?(LONGEST_DELIVER_TIME)

  include StateID
  enum state: [:active, :ended]

  # Couriers leave at DeliveryPlace for time_spent_in_place
  def deliver_to!(places: [], foods: [])
    places.each_with_index do |place, index|
      dp = delivery_places.create!(place: place, arrives_at: eta_for(index, places.count), current_index: index)
      foods.each { |food| dp.deliveries.create!(food: food) }
    end
  end

  # Given [1,2,3,4,5,6]
  # If new_zero_index's value was 3
  # Then, array should return [3,4,5,6,1,2]
  def update_delivery_times!
    new_zero_index = self.delivery_places.active.first.current_index
    count = self.delivery_places.count
    places = self.delivery_places.order("current_index DESC").to_a
    places[new_zero_index..places.length - 1]
      .push(*places[0..new_zero_index - 1])
      .uniq
      .each_with_index do |place, index|
        place.update_attributes!(current_index: index, arrives_at: eta_for(index, count))
      end
  end

  def eta_for(index, place_count)
    time_spent_in_place = LONGEST_DELIVER_TIME / place_count.to_f
    (time_spent_in_place * (index + 1)).minutes.from_now
  end

  validates :courier, presence: true
  validates :seller, presence: true

  # Only one active Shift at a given time for a Courier
  validates :state, uniqueness: { scope: [:courier] }, if: :active?

  before_validation on: :create do
    self.seller = courier.seller
  end

end
