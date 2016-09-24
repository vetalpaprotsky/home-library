class Category < ActiveRecord::Base
  has_many :books
  
  validates :name, presence: true
  default_scope -> { order('name ASC') }
end
