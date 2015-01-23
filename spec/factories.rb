unless defined?(FOOD_IMAGES)
  FOOD_IMAGES = [
    "http://www.papabellaspizzeria.com/Pizza_files/Pepperoni_1.jpg",
    "http://s3.amazonaws.com/gmi-digital-library/a5371459-75b5-4545-b1b9-89bcf1ffb9dc.jpg",
    "https://38.media.tumblr.com/tumblr_mef4ddwioU1rum6sio1_500.png",
    "http://www.madforbusiness.com/wp-content/uploads/2013/08/Ice-Cream-Sandwich-Yum1.jpg",
    "http://unconfidentialcook.files.wordpress.com/2009/12/dsc_0011.jpg"
  ]
end

unless defined?(PLACES)
  PLACES = {
  "Boss House" => {
    latitude: 40.4415977,
    longitude: -79.9393133
  },
  "Doherty Apartments" => {
    latitude: 40.4444299,
    longitude: -79.9390354
  },
  "Donner" => {
    latitude: 40.4419354,
    longitude: -79.9401781
  },
  "Fairfax" => {
    latitude: 40.4468557,
    longitude: -79.9481336
  },
  "ΔΔΔ" => {
    longitude: 40.4451018,
    latitude: -79.9419017
  },
  "ΑΕΠ" => {
    longitude: 40.4447605,
    latitude: -79.9426024
  },
  "ΣΑΕ" => {
    longitude: 40.4449303,
    latitude: -79.9424954
  },
  "ΚΑΘ" => {
    longitude: 40.4451467,
    latitude: -79.9421494
  },
  "ΑΦ" => {
    longitude: 40.4452222,
    latitude: -79.9423586
  },
  "ΣΦΕ" => {
    longitude: 40.4457315,
    latitude: -79.9415754
  },
  "ΦΔΘ" => {
    longitude: 40.445796,
    latitude: -79.941866
  },
  "ΚΣ" => {
    longitude: 40.4455397,
    latitude: -79.9414252
  },
  "ΚΚΓ" => {
    longitude: 40.4453607,
    latitude: -79.941481
  },
  "ΑΧΩ" => {
    longitude: 40.4450089,
    latitude: -79.9416625
  },
  "ΔΤΔ" => {
    longitude: 40.444614,
    latitude: -79.9413782
  },
  "ΔΓ" => {
    longitude: 40.4446823,
    latitude: -79.9415874
  },
  "ΠΚΑ" => {
    longitude: 40.442074,
    latitude: -79.938624
  },
  "ΣΝ" => {
    longitude: 40.442037,
    latitude: -79.938695
  },
  "ΛΦΕ" => {
    longitude: 40.442004,
    latitude: -79.938774
  },
  "ΣΧ" => {
    longitude: 40.441949,
    latitude: -79.938917
  },
  "ΣΧ" => {
    longitude: 40.441949,
    latitude: -79.938917
  },
  "ΔΥ" => {
    longitude: 40.441919,
    latitude: -79.939000
  },
  "Henderson House" => {
    latitude: 40.4409919,
    longitude: -79.9392516
  },
  "Margaret Morrison Plaza" => {
    latitude: 40.4417488,
    longitude: -79.9384917
  },
  # "Margaret Morrison Fraternity" => {
  #   latitude: 40.4419765,
  #   longitude: -79.9387316
  # },
  "McGill House" => {
    latitude: 40.4417167,
    longitude: -79.9390194
  },
  "Morewood" => {
    latitude: 40.4454444,
    longitude: -79.9432431
  },
  "Mudge" => {
    latitude: 40.4468909,
    longitude: -79.9429664
  },
  "Neville Apartments" => {
    latitude: 40.4474732,
    longitude: -79.9471787
  },
  # "Resnik House" => {
  #
  # },
  "Roselawn" => {
    latitude: 40.4420264,
    longitude: -79.9381577
  },
  "Scobell House" => {
    latitude: 40.441344,
    longitude: -79.9396235
  },
  "Shady Oak Apartments" => {
    latitude: 40.448825,
    longitude: -79.9463025
  },
  "Shirley Apartments" => {
    latitude: 40.4476771,
    longitude: -79.9514109
  },
  "Spirit House" => {
    latitude: 40.4423254,
    longitude: -79.9379408
  },
  "Stever" => {
    latitude: 40.4462907,
    longitude: -79.942651
  },
  "Res on Fifth" => {
    latitude: 40.446866,
    longitude: -79.946843
  },
  "Webster" => {
    latitude: 40.4473164,
    longitude: -79.9514019
  },
  "Welch House" => {
    latitude: 40.4411455,
    longitude: -79.9394653
  },
  "West Wing" => {
    latitude: 40.4427468,
    longitude: -79.9408447
  },
  "Woodlawn" => {
    latitude: 40.4424402,
    longitude: -79.9377206
  },
  "99 Gladstone" => {
    latitude: 40.4417064,
    longitude: -79.9377826
  },
  "1094 Devon" => {
    latitude: 40.4451987,
    longitude: -79.9410139
  },
  "Alumni House" => {
    latitude: 40.4447429,
    longitude: -79.9420917
  },
  "Art Park" => {
    latitude: 40.4443071,
    longitude: -79.9472501
  },
  "Baker Hall" => {
    latitude: 40.4443071,
    longitude: -79.9472501
  },
  "Porter Hall" => {
    latitude: 40.4417255,
    longitude: -79.9463108
  },
  "Bramer House" => {
    latitude: 40.4459806,
    longitude: -79.941031
  },
  "CFA" => {
    latitude: 40.4413865,
    longitude: -79.971262
  },
  "Cyert Hall" => {
    latitude: 40.4442762,
    longitude: -79.9439342
  },
  "Doherty Hall" => {
    latitude: 40.4423925,
    longitude: -79.9443068
  },
  # "Facilities Management Services Building" => {
  #   latitude: 40.4433485,
  #   longitude: -79.9464634
  # },
  "Gates (5th Floor)" => {
    latitude: 40.443719,
    longitude: -79.944564
  },
  "Hillman Center" => {
    latitude: 40.443719,
    longitude: -79.944564
  },
  "Hamburg Hall" => {
    latitude: 40.4441734,
    longitude: -79.9455542
  },
  "Hamerschlag Hall" => {
    latitude: 40.4424073,
    longitude: -79.9469101
  },
  "Hunt Library" => {
    latitude: 40.4411107,
    longitude: -79.9437323
  },
  # "Jared L. Cohon University Center" => {
  #
  # },
  "Margaret Morrison Hall" => {
    latitude: 40.4420304,
    longitude: -79.9414491
  },
  "Newell-Simon Hall" => {
    latitude: 40.4433813,
    longitude: -79.9455855
  },
  "Tepper" => {
    latitude: 40.441096,
    longitude: -79.942273
  },
  "Purnell" => {
    latitude: 40.4435574,
    longitude: -79.9435249
  },
  "Rand Building" => {
    latitude: 40.4465932,
    longitude: -79.9493198
  },
  # "Roberts Engineering Hall" => {
  #
  # },
  # "Robert Mehrabian Collaborative" => {
  #   latitude: 40.444057,
  #   longitude: -79.946523
  # },
  "Scaife Hall" => {
    latitude: 40.443108,
    longitude: -79.9613592
  },
  # "Future Home of Sherman and Joyce Bowie Scott Hall" => {
  #
  # },
  "Skibo Gymnasium" => {
    latitude: 40.440997,
    longitude: -79.9414337
  },
  "Smith Hall" => {
    latitude: 40.4439719,
    longitude: -79.9455384
  },
  "SEI" => {
    latitude: 40.446474,
    longitude: -79.950089
  },
  "Solar Decathlon House" => {
    latitude: 40.4422193,
    longitude: -79.9405122
  },
  "Warner Hall" => {
    latitude: 40.4441647,
    longitude:-79.9433725
  },
  "Wean (La Prima Cafe)" => {
    latitude: 40.442668,
    longitude: -79.9457525
  },
  "Whitfield Hall (HR)" => {
    latitude: 40.448419,
    longitude: -79.9501861
  },
}
end

FactoryGirl.define do


  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "1925#{rand(1111111..9999999)}" }
    facebook_uid { String(rand(11111..99999)) }
    state 1

    school { create(:school) }

    factory :registered_user do
      state 0
    end

    after(:create) do |user|
      create(:payment_method, user_id: user.id)
    end

  end

  factory :base_food do
    title { Faker::Lorem.words(2).join(" ").titleize }
    description { Faker::Lorem.sentences(2).join(" ") }
    goal { rand(100..300) }
    seller_id { FactoryGirl.create(:seller).id }
    restaurant_id { create(:restaurant).id }

    factory :food, class: Food do
      end_date 6.hours.from_now
      start_date 3.hours.ago
      type "Food"
      # preview { open(FOOD_IMAGES.sample) }
    

      factory :halted_food do
        state Food.states[:halted]
      end

      factory :ended_food do
        state Food.states[:ended]
      end

      factory :pending_food do
        start_date 3.weeks.from_now
        end_date 6.weeks.from_now
      end

      factory :expired_food do
        end_date 2.hours.ago
      end
    end

    factory :sellable_food do
      type "SellableFood"
    end

    after(:create) do |food|
      food.set_prices!([rand(300..500)])
    end
  end

  factory :seller do
    name { Faker::Company.name }
    #logo { open(Faker::Company.logo) }
    school { create(:school) }
  end

  factory :courier do
    seller { FactoryGirl.create(:seller) }
    user { FactoryGirl.create(:user) }

    factory :active_courier do
      state Courier.states[:active]
    end
  end

  factory :shift do
    courier { FactoryGirl.create(:courier) }
    state Shift.states[:ended]

    factory :active_shift do
      state Shift.states[:active]

      after(:create) do |shift|
        4.times do |i|
          place = FactoryGirl.create(:place)
          dp = FactoryGirl.create(:delivery_place, place_id: FactoryGirl.create(:place).id, shift_id: shift.id, current_index: i)
          dp.deliveries.create!(food_id: create(:food, seller_id: shift.seller_id).id)
        end
      end

      factory :ended_shift do
        state Shift.states[:ended]

        after(:create) do |shift|
          shift.delivery_places.update_all(state: DeliveryPlace.states[:ended])
        end

      end

    end
  end

  factory :delivery_place do
    place_id { FactoryGirl.create(:place).id }
    shift_id { FactoryGirl.create(:shift).id }
    arrives_at 15.minutes.from_now
    current_index nil
    state DeliveryPlace.states[:pending]
  end

  factory :location do
    name { Faker::Address.street_name }
    phone { Faker::PhoneNumber.phone_number }
    address_one { Faker::Address.street_address }
    address_two { Faker::Address.secondary_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end

  factory :place do
    name do
      remaining_names = PLACES.keys | Place.where(name: PLACES.keys).pluck(:name)
      remaining_names.sample
    end

    school do
      create(:school)
    end

    location do |place|
      FactoryGirl.create(:location, latitude: PLACES[place.name][:latitude], longitude: PLACES[place.name][:longitude])
    end

  end

  factory :order do |o|
    user_id { create(:user).id }
    food_id { create(:food).id }
    price_id { |o| Price.where(food_id: o.food_id).first.id }
  end

  factory :session do
    access_token SecureRandom.urlsafe_base64
    user_id { create(:user).id }
  end

  factory :payment_method do
    customer SecureRandom.urlsafe_base64
  end

  factory :promo do
    discount_in_cents 100
    name { SecureRandom.urlsafe_base64 }
  end

end

class TestHelpers
  module Order
    def self.create_for(user: nil, params: {})
      courier = FactoryGirl.create(:active_courier)
      shift = FactoryGirl.create(:active_shift, courier_id: courier.id)
      place = FactoryGirl.create(:place)
      delivery_place = FactoryGirl.create(:delivery_place, shift_id: shift.id, place_id: place.id)
      food = FactoryGirl.create(:food, seller_id: courier.seller_id, start_date: 1.seconds.ago)
      Delivery.create!(food: food, delivery_place: delivery_place)

      params[:place_id] ||= place.id
      params[:food_id]  ||= food.id
      params[:price_id] ||= food.prices.first.id
      params[:user_id]  ||= user.try(:id) || FactoryGirl.create(:user).id
      ::Order.create!(params)
    end
  end
end
