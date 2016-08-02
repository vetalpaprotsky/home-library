require 'faker'

FactoryGirl.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    author { Faker::Book.author }
    association :user, factory: :user
  end
end
