class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_book, only: [:new, :create]
  before_action :find_review, only: [:edit, :update, :destroy]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.book_id = @book.id
    @review.user_id = current_user.id

    if @review.save
      redirect_to book_path(@book)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to book_path(@review.book)
    else
      render 'edit'
    end
  end

  def destroy
    book = @review.book
    @review.destroy
    redirect_to book_path(book)
  end

  private

    def review_params
      params.require(:review).permit(:rating, :comment)
    end

    def find_book
      @book = Book.find(params[:book_id])
    end

    def find_review
      @review = current_user.reviews.find(params[:id])
    end
end
