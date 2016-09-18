class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :comment, :book_id, :user_id, presence: true
end
