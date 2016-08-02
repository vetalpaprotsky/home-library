class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates :title, :description, :author, :user_id, presence: true
end
