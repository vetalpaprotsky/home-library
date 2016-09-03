FactoryGirl.define do
  factory :review do
    rating 1
    comment { Faker::Lorem.paragraph }
    association :user, factory: :user
    association :book, factory: :book
  end

  factory :invalid_review, parent: :review do
    rating -1
  end
end