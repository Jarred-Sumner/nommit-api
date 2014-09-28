class CreateFoodInteractor

  def self.create!(food: Food.new, places: [])
    places.each_with_index do |place, index|
      food.food_delivery_places.create!(place: place, state: 1)
    end
  end

end
