namespace :fake_data do
  desc "Fill database with fake data"
  task populate: :environment do
    make_users
    make_books
    make_reviews
  end
end

#NUMBER_OF_USERS   = 20
#NUMBER_OF_BOOKS   = 100
#NUMBER_OF_REVIEWS = 15

def make_users
  20.times do
    User.create!(email:                 Faker::Internet.email,
                 password:              "37zudohov",
                 password_confirmation: "37zudohov")
  end
end

def make_books
  categories = Category.all
  users = User.all

  100.times do
    users.sample.books.create!(title:       Faker::Book.title,
                               description: Faker::Lorem.paragraph(7),
                               author:      Faker::Book.author,
                               category_id: categories.sample.id)
  end
end

def make_reviews
  books = Book.all
  users = User.all

  books.each do |book|
    random_users = []
    rand(15).times { random_users << users.sample }
    random_users.each do |user|
      user.reviews.create!(comment: rand(3) == 0 ? "" : Faker::Lorem.paragraph,
                           rating:  rand(1..5),
                           book_id: book.id)
    end
  end
end
