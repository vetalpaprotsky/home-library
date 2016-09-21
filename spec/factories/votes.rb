FactoryGirl.define do
  factory :vote do
    rating 2
    association :user, factory: :user
    association :book, factory: :book
  end
end
