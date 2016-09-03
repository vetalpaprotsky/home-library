FactoryGirl.define do
  factory :review do
    rating 1
    comment { Faker::Lorem.paragraph }
    association :user, factory: :user
    association :book, factory: :book
  end
end
