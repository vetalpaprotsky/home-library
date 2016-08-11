class AddBookIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :book_id, :integer, index: true
  end
end
