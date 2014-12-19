module Tracking
  extend ActiveSupport::Concern

  def track(event_name, properties = {})
    metadata = {
      'App Version' => request.headers["X-APP-VERSION"],
      'App Platform' => request.headers["X-APP-PLATFORM"],
      'User Signed In' => current_user.present?,
      'User State' => current_user.try(:state)
    }
    Analytics.track(event: event_name, properties: properties.merge(metadata), user_id: current_user.try(:id))
  end


  # Long list of events!

  ## User Events

  def track_activation
    track("User Activated")
  end

  def track_sign_in
    track("User Signed In")
  end

  def track_applied_promo
    track("User Applied Promo")
  end

  def track_update_payment_method
    track("User Updated Payment Method")
  end

  def track_sent_confirm_code
    track("User Sent Confirm Code")
  end

  ## Device Events

  def track_registered_for_push
    track("Registered for Push Notifications")
  end

  ## Order Events

  def track_placed_order(order)
    track("Placed Order", track_properties_for(order: order))
  end

  def track_delivered_order(order)
    track("Delivered Order", track_properties_for(order: order))
  end

  def track_rated_order(order)
    track("Rated Order", track_properties_for(order: order))
  end

  ## Shift Events

  def track_started_shift(shift)
    track("Courier Started Shift", track_properties_for(shift: shift))
  end

  def track_halted_shift(shift)
    track("Courier Halted Shift", track_properties_for(shift: shift))
  end

  def track_ended_shift(shift)
    track("Courier Ended Shift", track_properties_for(shift: shift))
  end

  def track_shift_changed_delivery_places(shift)
    track("Courier Changed Delivery Places", track_properties_for(shift: shift))
  end

  ## Place Events Events

  def track_checked_for_food(place)
    track("User Checked for Food", track_properties_for(place: place))
  end

  def track_looked_at_places
    track("User Looked at Places", track_properties_for(school: school))
  end


  # Food Events

  def track_food_sold_out(food)
    track("Food Sold Out", track_properties_for(food: food))
  end

  ## Delivery Place Events

  def track_delivery_place_arrived(delivery_place)
    track("Courier Arrived", track_properties_for(delivery_place: delivery_place))
  end


  private

    def track_properties_for(order: nil, seller: nil, food: nil, place: nil, user: nil, courier: nil, shift: nil, delivery_place: nil, school: nil)
      if order.present?
        food_props = track_properties_for(food: order.food)
        place_props = track_properties_for(place: order.place)
        return {
          'Order Quantity' => order.quantity,
          'Order Price' => order.price_in_cents,
          'Order Discount' => order.discount_in_cents,
          'Order Tip' => order.tip_in_cents,
          'Order ID' => order.id,
          'Order State' => order.state,
          'Order Delivery Estimate' => order.delivered_at,
          'Order Original Delivery Estimate' => order.original_delivered_at
        }.merge(food_props).merge(place_props)
      end

      if food.present?
        return seller_props = track_properties_for(seller: food.seller)
        {
          "Food Name" => food.name,
          "Food ID" => food.id,
          "Food State" => food.state,
          "Food Goal" => food.goal,
          "Food Sold" => food.orders.count
        }.merge(seller_props)
      end

      if seller.present?
        return {
          'Seller ID' => seller.id,
          'Seller Name' => seller.name,
        }.merge(track_properties_for(school: seller.school))
      end

      if place.present?
        return {
          'Place Name' => place.name,
          'Place ID' => place.id
        }.merge(track_properties_for(school: place.school))
      end

      if shift.present?
        seller_params = track_properties_for(seller: shift.seller)
        return {
          'Shift State' => shift.state,
          'Shift Ended At' => shift.ended_at,
          'Shift ID' => shift.id,
          'Number of Delivery Places' => shift.delivery_places.count
        }.merge(seller_params)
      end

      if school.present?
        return {
          'School Name' => school.name
        }
      end

      if delivery_place.present?
        shift_params = track_properties_for(shift: delivery_place.shift)
        place_params = track_properties_for(place: delivery_place.place)
        shift_params.merge(place_params)
      end


    end
end
