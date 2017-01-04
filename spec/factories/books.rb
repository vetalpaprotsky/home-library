require 'faker'

FactoryGirl.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(7) }
    author { Faker::Book.author }
    association :user, factory: :user
    categories {[FactoryGirl.create(:category)]}
  end

  factory :invalid_book, parent: :book do
    title nil
  end
end
