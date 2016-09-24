class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :text, :book_id, :user_id, presence: true
  default_scope -> { order('created_at DESC') }
end
