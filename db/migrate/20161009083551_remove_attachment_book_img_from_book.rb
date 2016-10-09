class RemoveAttachmentBookImgFromBook < ActiveRecord::Migration
  def self.up
    remove_attachment :books, :book_img
  end

  def self.down
    change_table :books do |t|
      t.attachment :book_img
    end
  end
end
