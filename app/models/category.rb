class Category < ActiveRecord::Base
  has_many :books

  validates :name, presence: true
  default_scope -> { order('name ASC') }

  after_commit :flush_cache

  def self.cached_categories
    Rails.cache.fetch('all_categories') { self.all.to_a }
  end

  private

    def flush_cache
      Rails.cache.delete('all_categories')
    end
end
