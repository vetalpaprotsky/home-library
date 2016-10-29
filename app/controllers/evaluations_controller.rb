class EvaluationsController < ApplicationController
  respond_to :js

  def evaluate
    if current_user.nil?
      render 'authenticate_user'
    else
      @book = Book.find(params[:book_id])
      if @book.user != current_user
        @evaluation = current_user.evaluations.where(book_id: @book.id).first

        if @evaluation.nil?
          @new_evaluation = true
          @evaluation = current_user.evaluations.build(evaluations_params)
          @evaluation.book_id = @book.id
          @evaluation.save
        else
          @evaluation.update(evaluations_params)
        end
      end

      if @evaluation.try(:valid?)
        @average_book_evaluation = @book.average_evaluation
      else
        render nothing: true
      end
    end
  end

  private

    def evaluations_params
      params.require('evaluation').permit('value')
    end
end
