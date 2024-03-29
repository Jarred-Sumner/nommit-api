
school = School.create!(name: "Carnegie Mellon University", from_hours: Time.parse("8:00 PM"), to_hours: Time.parse("12:00 AM"))

PLACES.keys.each do |name|
  place = PLACES[name]
  location = Location.create!(latitude: place[:latitude], longitude: place[:longitude])
  Place.create!(name: name, location: location, school: school)
end

trisigma = Seller.create! do |s|
  s.name = "Sigma Sigma Sigma"
  s.logo = open("http://media-cache-ak0.pinimg.com/736x/48/cf/4d/48cf4da6e1cc673ce05da861d3cba5c6.jpg")
  s.school = school
end

tridelta = Seller.create! do |s|
  s.name = "Delta Delta Delta"
  s.logo = open("http://i.imgur.com/Jq4kxzw.png")
  s.school = school
end

j_user = User.create!(facebook_uid: "10203816999219792", email: "jarred@jarredsumner.com", name: "Jarred Sumner", state: 1, phone: "+19252008843")
l_user = User.create!(facebook_uid: "10152442953459538", email: "lguo@andrew.cmu.edu", name: "Lucy Guo", state: 1, phone: "+19255968005")

User.update_all(school_id: school.id)

j_courier = Courier.create!(seller: trisigma, user: j_user)
l_courier = Courier.create!(seller: tridelta, user: l_user)

j_shift = j_courier.shifts.create!
l_shift = l_courier.shifts.create!

pizza = Food.create! do |f|
  f.title = "1x Pepperoni Pizza (Slice)"
  f.description = "This is one scrum-diddly-umptious slice of pepperoni pizza"
  f.seller = tridelta
  f.goal = 75
  f.start_date = 5.minutes.ago
  f.end_date = 22.days.from_now
  f.preview = open("http://www.papabellaspizzeria.com/Pizza_files/Pepperoni_1.jpg")
end
pizza.set_prices!([425, 625])

cookies = Food.create! do |f|
  f.title = "3 x Chocalate Chip Cookie"
  f.description = "Artisan Italian chocalate chips, cookie dough from the finest Israeli lait, at a size crafted for hungry college students."
  f.seller = tridelta
  f.goal = 100
  f.start_date = 5.minutes.ago
  f.end_date = 22.days.from_now
  f.preview = open("http://s3.amazonaws.com/gmi-digital-library/a5371459-75b5-4545-b1b9-89bcf1ffb9dc.jpg")
end
cookies.set_prices!([300, 500])


nuggets = Food.create! do |f|
  f.title = "3 x Chicken Nuggets"
  f.description = "Dinosaur chicken nuggets. Delivered. You heard correctly. Ketchup included."
  f.seller = trisigma
  f.goal = 50
  f.start_date = 5.minutes.ago
  f.end_date = 22.days.from_now
  f.preview = open("https://38.media.tumblr.com/tumblr_mef4ddwioU1rum6sio1_500.png")
end
nuggets.set_prices!([300, 400, 400])

expired = FactoryGirl.create(:expired_food, seller_id: trisigma.id)
pending = FactoryGirl.create(:pending_food, seller_id: trisigma.id)

shared_place_one = Place.random.id
shared_place_two = Place.random.id

l_shift.deliver_to!(places: [shared_place_one, shared_place_two, Place.random.id])
j_shift.deliver_to!(places: [shared_place_one, shared_place_two, Place.random.id])
