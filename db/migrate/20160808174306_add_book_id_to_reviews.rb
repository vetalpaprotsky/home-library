class AddBookIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :book_id, :integer
    add_index :reviews, :book_id
  end
end
