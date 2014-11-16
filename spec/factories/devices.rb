# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    token { SecureRandom.urlsafe_base64 }
    registered true
    last_notified "2014-11-02 16:54:20"
    user { create(:user) }
    platform 0
  end
end
