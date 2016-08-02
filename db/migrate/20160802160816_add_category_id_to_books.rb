class AddCategoryIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :category_id, :integer, index: true
  end
end
