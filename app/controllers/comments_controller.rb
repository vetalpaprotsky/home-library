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
    @new_comment = Comment.new

    respond_to do |format|
      if @comment.save
        format.html { redirect_to book_path(@book) }
        format.js
      else
        format.html { render 'new' }
        format.js { render 'not_created' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to book_path(@comment.book) }
        format.js
      else
        format.html { render 'edit' }
        format.js { render 'not_updated' }
      end
    end
  end

  def destroy
    book = @comment.book
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to book_path(book) }
      format.js { render json: true }
    end
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
