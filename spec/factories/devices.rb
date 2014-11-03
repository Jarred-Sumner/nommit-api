# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    token "MyText"
    registered false
    last_notified "2014-11-02 16:54:20"
    user nil
    platform 1
  end
end
