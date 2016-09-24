class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :value,  default: 1
      t.integer :user_id, index: true
      t.integer :book_id, index: true
      t.timestamps null: false
    end
    add_index :evaluations, [:user_id, :book_id], unique: true
  end
end
