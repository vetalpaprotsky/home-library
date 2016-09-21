class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :rating,  default: 1
      t.integer :user_id, index: true
      t.integer :book_id, index: true
      t.timestamps null: false
    end
    add_index :votes, [:user_id, :book_id], unique: true
  end
end
