class Category < ActiveRecord::Base
  has_many :books

  def self.order_desc_by_name
    order('name DESC')
  end
end
