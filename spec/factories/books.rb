require 'faker'

FactoryGirl.define do
  factory :book do |f|
    f.title { Faker::Book.title }
    f.description { Faker::Lorem.paragraph }
    f.author { Faker::Book.author }
  end
end
