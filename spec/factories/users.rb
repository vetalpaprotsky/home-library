require 'faker'

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password '123456'
    after(:create) { |user| user.confirm }
  end
end
