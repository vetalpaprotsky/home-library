FactoryGirl.define do
  factory :review do
    comment { Faker::Lorem.paragraph }
    association :user, factory: :user
    association :book, factory: :book
  end

  factory :invalid_review, parent: :review do
    comment nil
  end
end
