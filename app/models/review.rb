class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :rating, :comment, :book_id, :user_id, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1,
                                        less_than_or_equal_to: 5 }
end
