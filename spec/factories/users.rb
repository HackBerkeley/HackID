# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "test@example.com"
    username "TestUser"
    password "testthis"
    password_confirmation "testthis"
    remember_me true
  end
end
