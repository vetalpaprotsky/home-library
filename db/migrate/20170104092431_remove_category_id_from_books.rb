class RemoveCategoryIdFromBooks < ActiveRecord::Migration
  def up
    remove_column :books, :category_id
  end

  def down
    add_column :books, :category_id, :integer
    add_index :books, :category_id
  end
end
