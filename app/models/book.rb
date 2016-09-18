class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  validates :title, :description, :author, :user_id, :category_id, presence: true
  validates :description, length: { minimum: 127 }

  has_attached_file :book_img, styles: { book_index: "250x350>", book_show: "325x475>" },
                    default_url: ':style/missing.png'
  validates_attachment_content_type :book_img, content_type: /\Aimage\/(jpg|jpeg|png)\z/
  validates_with AttachmentSizeValidator, attributes: :book_img, less_than: 1.megabytes
end
