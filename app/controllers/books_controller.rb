class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action :get_categories_for_select, only: [:new, :edit]

  def index
    @books = if params[:category].blank?
               Book.all.order('created_at DESC')
             else
               category_id = Category.find_by(name: params[:category])
               Book.where(category_id: category_id)
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
      redirect_to root_path
    else
      get_categories_for_select
      render 'new'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book # book_path(@book)
    else
      render 'edit'
    end
  end

  def destroy
    @book.destroy
    redirect_to root_path
  end

  private

    def book_params
      params.require(:book).permit(:title, :description, :author, :category_id)
    end

    def find_book
      @book = Book.find(params[:id])
    end

    def get_categories_for_select
      @categories = Category.order_asc_by_name.map { |c| [c.name, c.id] }
    end

end
