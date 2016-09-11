class Language < ActiveRecord::Base
  validates :name, :abbr, presence: true
  default_scope -> { order('abbr ASC') }
end
