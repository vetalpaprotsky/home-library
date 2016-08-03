class Category < ActiveRecord::Base
  has_many :books
  validates :name, presence: true

  def self.order_asc_by_name
    order('name ASC')
  end
end
