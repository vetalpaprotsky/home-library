class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_book, only: :show
  before_action :find_book_for_current_user, only: [:edit, :update, :destroy]

  def index
    @books = if params[:category].blank?
               Book.all.order('created_at DESC')
             else
               category_id = Category.find_by(name: params[:category])
               Book.where(category_id: category_id).order('created_at DESC')
             end
  end

  def show
    @average_rating = if @book.reviews.blank?
                        0
                      else
                        @book.reviews.average(:rating).round(2)
                      end
  end

  def new
    @book = current_user.books.build
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to books_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book)
    else
      render 'edit'
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

    def book_params
      params.require(:book).permit(:title,  :description,
                                   :author, :category_id, :book_img)
    end

    def find_book
      @book = Book.find(params[:id])
    end

    def find_book_for_current_user
      @book = current_user.books.find(params[:id])
    end
end
