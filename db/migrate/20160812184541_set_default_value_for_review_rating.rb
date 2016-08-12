class SetDefaultValueForReviewRating < ActiveRecord::Migration
  def change
    change_column :reviews, :rating, :integer, default: 1
  end
end
