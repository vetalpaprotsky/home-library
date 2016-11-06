class Language < ActiveRecord::Base
  validates :name, :abbr, presence: true

  default_scope -> { order('abbr ASC') }

  after_commit :flush_cache

  def self.cached_languages
    Rails.cache.fetch('all_languages') { self.all.to_a }
  end

  private

    def flush_cache
      Rails.cache.delete('all_languages')
    end
end
