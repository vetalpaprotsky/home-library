class RenameReviewsToComments < ActiveRecord::Migration
  def change
    rename_table :reviews, :comments
  end
end
