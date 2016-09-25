class SetDefaultValueForReviewRating < ActiveRecord::Migration
  def up
    change_column :reviews, :rating, :integer, default: 1
  end

  def down
    change_column :reviews, :rating, :integer
  end
end
