# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    last_pushed "2014-11-16 15:52:10"
    last_texted "2014-11-16 15:52:10"
    last_emailed "2014-11-16 15:52:10"
    user nil
  end
end
