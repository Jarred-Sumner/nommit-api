class EndFoodWorker
  include Sidekiq::Worker

  def perform(food_id)
    food = Food.find(food_id)

    if food.end_date.past?
      food.update_attributes!(state: Food.states[:ended])
    else
      EndFoodWorker.perform_at(food.end_date + 5.minutes, food.id)
    end

  end

end
