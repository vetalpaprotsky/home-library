class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates :title, :description, :author, :user_id, :category_id, presence: true
  validates :title, :author, length: { minimum: 2, maximum: 255 }
  validates :description, length: { minimum: 127 }
end
