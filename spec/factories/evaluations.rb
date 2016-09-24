FactoryGirl.define do
  factory :evaluation do
    value 2
    association :user, factory: :user
    association :book, factory: :book
  end
end
