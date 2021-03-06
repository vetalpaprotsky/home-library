require 'file_size_validator'

class Book < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :comments, dependent: :destroy
  has_many :evaluations, dependent: :destroy
  validates :title, :description, :author, :user_id, presence: true
  validates :description, length: { minimum: 50 }
  validates :categories, length: { minimum: 1 }

  mount_uploader :image, BookImageUploader
  validates :image, file_size: { maximum: 1.megabyte.to_i }

  def average_evaluation
    number_of_evaluations = summa_of_evaluations = 0
    self.evaluations.each do |evl|
      summa_of_evaluations += evl.value
      number_of_evaluations += 1
    end
    avg = summa_of_evaluations.to_f / number_of_evaluations
    avg.nan? ? 0 : avg
  end
end
