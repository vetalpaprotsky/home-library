class Evaluation < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :value, :user_id, :book_id, presence: :true
  validates :value, inclusion: 1..5
end
