class Book < ActiveRecord::Base
  validates :title, :description, :author, presence: true
end
