# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price do
    quantity 1
    price_in_cents 1
    food nil
  end
end
