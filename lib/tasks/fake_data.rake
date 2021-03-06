namespace :fake_data do
  desc "Fill database with fake data"
  task populate: :environment do
    Admin.delete_all
    User.delete_all
    Book.delete_all
    Comment.delete_all
    Evaluation.delete_all

    make_admin
    make_users
    make_books
    make_comments
    make_evaluations
  end
end

NUMBER_OF_USERS                = 20
NUMBER_OF_BOOKS                = 100
NUMBER_OF_COMMENTS_FOR_BOOK    = 15
NUMBER_OF_EVALUATIONS_FOR_BOOK = 20

def make_admin
  Admin.create(email:    "vetalpaprotsky@gmail.com",
               password: "12345678")
end

def make_users
  NUMBER_OF_USERS.times do
    user = User.new(name:     Faker::Name.name,
                    email:    Faker::Internet.email,
                    password: "12345678")
    user.skip_confirmation!
    user.save!
  end
end

def make_books
  categories = Category.all
  users = User.all

  NUMBER_OF_BOOKS.times do
    users.sample.books.create!(title:       Faker::Book.title,
                               description: Faker::Lorem.paragraph(7),
                               author:      Faker::Book.author,
                               categories:  categories.sample(rand(1..7)))
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

  def make_evaluations
    books = Book.last(NUMBER_OF_BOOKS)
    users = User.last(NUMBER_OF_USERS)

    books.each do |book|
      random_users = []
      rand(NUMBER_OF_EVALUATIONS_FOR_BOOK).times { random_users << users.sample }
      random_users.uniq.each do |user|

        user.evaluations.create!(value: rand(1..5),
                                 book_id: book.id)
      end
    end
  end
end
