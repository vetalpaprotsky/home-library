class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :redirect_to_index_if_current_user_does_not_own_book,
                only: [:edit, :update, :delete]

  def index
    @books = if params[:category].blank?
               Book.all.order('created_at DESC')
             else
               category_id = Category.find_by(name: params[:category])
               Book.where(category_id: category_id).order('created_at DESC')
             end
  end

  def show
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
      params.require(:book).permit(:title, :description, :author, :category_id)
    end

    def find_book
      @book = Book.find(params[:id])
    end

    def redirect_to_index_if_current_user_does_not_own_book
      redirect_to books_path if @book.user != current_user
    end

end
