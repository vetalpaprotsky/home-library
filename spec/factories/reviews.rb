FactoryGirl.define do
  factory :comment do
    text { Faker::Lorem.paragraph }
    association :user, factory: :user
    association :book, factory: :book
  end

  factory :invalid_comment, parent: :comment do
    text nil
  end
end
