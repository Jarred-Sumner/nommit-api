# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :school do
    name { Faker::Address.street_name }
    from_hours "2014-12-15 16:12:26"
    to_hours "2014-12-15 16:12:26"
  end
end
