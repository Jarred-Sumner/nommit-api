# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :motd do
    message "MyString"
    expiration "2014-12-19 11:26:05"
    school nil
  end
end
