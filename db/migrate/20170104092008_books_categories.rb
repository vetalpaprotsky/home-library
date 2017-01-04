class BooksCategories < ActiveRecord::Migration
  def change
    create_table :books_categories do |t|
      t.belongs_to :book, index: true
      t.belongs_to :category, index: true
    end
  end
end
