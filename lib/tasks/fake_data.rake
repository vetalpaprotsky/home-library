namespace :fake_data do
  desc "Fill database with fake data"
  task populate: :environment do
    make_users
    make_books
    make_comments
  end
end

NUMBER_OF_USERS             = 20
NUMBER_OF_BOOKS             = 100
NUMBER_OF_COMMENTS_FOR_BOOK = 15

def make_users
  NUMBER_OF_USERS.times do
    User.create!(email:                 Faker::Internet.email,
                 password:              "37zudohov",
                 password_confirmation: "37zudohov")
  end
end

def make_books
  categories = Category.all
  users = User.all

  NUMBER_OF_BOOKS.times do
    users.sample.books.create!(title:       Faker::Book.title,
                               description: Faker::Lorem.paragraph(7),
                               author:      Faker::Book.author,
                               category_id: categories.sample.id)
  end
end

def make_comments
  books = Book.all
  users = User.all

  books.each do |book|
    random_users = []
    rand(NUMBER_OF_COMMENTS_FOR_BOOK).times { random_users << users.sample }
    random_users.each do |user|
      user.comments.create!(text: Faker::Lorem.paragraph,
                            book_id: book.id)
    end
  end
end
