class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :book


  validates :rating, :user_id, :book_id, presence: :true
  validates :rating, inclusion: 1..5
end
