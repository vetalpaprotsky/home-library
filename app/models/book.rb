class Book < ActiveRecord::Base
  belongs_to :user
  validates :title, :description, :author, :user_id, presence: true
end
