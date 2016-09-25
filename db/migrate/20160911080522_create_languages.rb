class CreateLanguages < ActiveRecord::Migration
  def up
    create_table :languages do |t|
      t.string :name
      t.string :abbr
      t.timestamps null: false
    end
  end

  def down
    drop_table :languages
  end
end
