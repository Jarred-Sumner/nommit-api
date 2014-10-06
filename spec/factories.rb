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
  "Donner House" => {
    latitude: 40.4419354,
    longitude: -79.9401781
  },
  "Fairfax Apartments" => {
    latitude: 40.4468557,
    longitude: -79.9481336
  },
  "Fraternity/Sorority Quadrangle" => {
    longitude: 40.44556,
    latitude: -79.941909
  },
  "Hamerschlag House" => {
    longitude: 40.4412456,
    latitude: -79.9390432
  },
  "Henderson House" => {
    latitude: 40.4409919,
    longitude: -79.9392516
  },
  "Margaret Morrison Apartments/Plaza" => {
    latitude: 40.4417488,
    longitude: -79.9384917
  },
  "Margaret Morrison Fraternity" => {
    latitude: 40.4419765,
    longitude: -79.9387316
  },
  "McGill House" => {
    latitude: 40.4417167,
    longitude: -79.9390194
  },
  "Morewood Gardens (Housing Offices)" => {
    latitude: 40.4454444,
    longitude: -79.9432431
  },
  "Mudge House" => {
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
  "Roselawn Houses" => {
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
  "Stever House" => {
    latitude: 40.4462907,
    longitude: -79.942651
  },
  "The Residence on Fifth" => {
    latitude: 40.446866,
    longitude: -79.946843
  },
  "Webster Hall" => {
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
  "Woodlawn Apartments" => {
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
  "Baker Hall (Dietrich/H&SS)" => {
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
  "College of Fine Arts (CFA)" => {
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
  "Facilities Management Services Building" => {
    latitude: 40.4433485,
    longitude: -79.9464634
  },
  "Gates Center for Computer Science (SCS)" => {
    latitude: 40.443719,
    longitude: -79.944564
  },
  "Hillman Center for Future-Generation Technologies (SCS)" => {
    latitude: 40.443719,
    longitude: -79.944564
  },
  "Hamburg Hall (Heinz)" => {
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
  "Margaret Morrison Carnegie Hall" => {
    latitude: 40.4420304,
    longitude: -79.9414491
  },
  "Mellon Institute (MCS)" => {
    latitude: 40.44618,
    longitude: -79.951062
  },
  "National Robotics Engineering Center (NREC)" => {
    latitude: 40.472856,
    longitude: -79.965426
  },
  "Newell-Simon Hall (SCS)" => {
    latitude: 40.4433813,
    longitude: -79.9455855
  },
  "Pittsburgh Technology Center* (ETC)" => {
    latitude: 40.4460425,
    longitude: -79.9495774
  },
  "Posner Center" => {
    latitude: 40.4416213,
    longitude: -79.9424019
  },
  "Posner Hall (Tepper)" => {
    latitude: 40.441096,
    longitude: -79.942273
  },
  "Purnell Center for the Arts" => {
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
  "Robert Mehrabian Collaborative" => {
    latitude: 40.444057,
    longitude: -79.946523
  },
  "Scaife Hall (CIT)" => {
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
  "Software Engineering Institute (SEI)" => {
    latitude: 40.446474,
    longitude: -79.950089
  },
  "Solar Decathlon House" => {
    latitude: 40.4422193,
    longitude: -79.9405122
  },
  "Warner Hall (Office of Admission)" => {
    latitude: 40.4441647,
    longitude:-79.9433725
  },
  "Wean Hall" => {
    latitude: 40.442668,
    longitude: -79.9457525
  },
  "Whitfield Hall (HR)" => {
    latitude: 40.448419,
    longitude: -79.9501861
  },
  "300 South Craig (Police)" => {
    latitude: 40.4455908,
    longitude: -79.9492398
  },
  "311 South Craig" => {
    latitude: 40.4455225,
    longitude: -79.9483015
  },
  "407 South Craig" => {
    latitude: 40.4449953,
    longitude: -79.9484048
  },
  "4516 Henry (UTDC)" => {
    latitude: 40.4462639,
    longitude: -79.9496189
  },
  "4609 Henry (Dietrich/H&SS Grad Labs)" => {
    latitude: 40.4463639,
    longitude: -79.9488793
  },
  "4615 Forbes (GATF)" => {
    latitude: 40.444735,
    longitude: -79.9478446
  },
  "4616 Henry (INI)" => {
    latitude: 40.4460867,
    longitude: -79.9480539
  },
  "6555 Penn*" => {
    latitude: 40.455723,
    longitude: -79.913402
  },
}
end

FactoryGirl.define do

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "+1#{rand(2222222222..9999999999)}" }
    facebook_uid { String(rand(11111..99999)) }
    state 1

    factory :registered_user do
      state 0
    end
  end

  factory :food do
    title { Faker::Lorem.words(2).join(" ").titleize }
    description { Faker::Lorem.sentences(2).join(" ") }
    end_date 6.hours.from_now
    price_in_cents { rand(100..425) }
    goal { rand(100..300) }
    start_date 3.hours.from_now
    # preview { open(FOOD_IMAGES.sample) }
    seller_id { FactoryGirl.create(:seller).id }

    factory :halted_food do
      state Food.states[:halted]
    end

    factory :ended_food do
      state Food.states[:ended]
    end

  end

  factory :seller do
    name { Faker::Company.name }
    #logo { open(Faker::Company.logo) }
  end

  factory :courier do
    seller { FactoryGirl.create(:seller) }
    user { FactoryGirl.create(:user) }
  end

  factory :shift do
    courier { FactoryGirl.create(:courier) }
    state Shift.states[:ended]

    factory :active_shift do
      state Shift.states[:active]

      after(:create) do |shift|
        4.times do |i|
          place = FactoryGirl.create(:place)
          dp = FactoryGirl.create(:delivery_place, place_id: FactoryGirl.create(:place).id, shift_id: shift.id, current_index: i, start_index: i)
          dp.deliveries.create(food_id: create(:food).id)
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
    current_index 0
    start_index 0
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
      remaining_names.first
    end

    location do |place|
      FactoryGirl.create(:location, latitude: PLACES[place.name][:latitude], longitude: PLACES[place.name][:longitude])
    end

  end

  factory :session do
    access_token SecureRandom.urlsafe_base64
    user_id { create(:user).id }
  end

end
