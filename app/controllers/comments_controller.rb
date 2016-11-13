class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_book, only: [:new, :create]
  before_action :find_comment, only: [:edit, :update, :destroy]

  def new
    @comment = current_user.comments.build
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.book_id = @book.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to book_path(@book) }
        format.js
        #format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render 'new' }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to book_path(@comment.book)
    else
      render 'edit'
    end
  end

  def destroy
    book = @comment.book
    @comment.destroy
    redirect_to book_path(book)
  end

  private

    def comment_params
      params.require(:comment).permit(:text)
    end

    def find_book
      @book = Book.find(params[:book_id])
    end

    def find_comment
      @comment = current_user.comments.find(params[:id])
    end
end
