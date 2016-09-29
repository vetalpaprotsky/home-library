require 'rails_helper'

describe EvaluationsController do

  context 'SIGN OUT' do

    before { @book = FactoryGirl.create(:book) }

    describe 'POST evaluate' do

      it 'renders evaluations/authenticate_user template' do
        post :evaluate, book_id: @book.id, evaluation: {}, format: :js

        expect(response).to render_template 'evaluations/authenticate_user'
      end
    end
  end

  context 'SIGN IN' do

    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
      @book = FactoryGirl.create(:book)
    end

    describe 'POST create' do

      context 'book does not exist' do

        it 'raise ActiveRecord::RecordNotFound' do
          expect do
            post :evaluate, book_id: 9999, evaluation: {}, format: :js
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'book exists' do

        context 'VALID ATTRIBUTES' do

          before { @valid_atts = { value: 5 } }

          context 'book does not belong to current user' do

            context 'evaluation exists' do

              before do
                @evaluation = FactoryGirl.create(:evaluation, value: 1, book_id: @book.id, user_id: @user.id)
              end

              it 'renders nothing' do
                post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js

                expect(response.body).to be_blank
              end

              it 'updates evaluation' do
                post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js

                expect(@evaluation.reload.value).to eq @valid_atts[:value]
              end
            end

            context 'evaluation does not exist' do

              it 'renders nothing' do
                post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js

                expect(response.body).to be_blank
              end

              it 'creates new evaluation that belongs to current user' do
                expect do
                  post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js
                end.to change(@user.evaluations, :count).by(1)
              end

              it 'creates new evaluation that belongs to book' do
                expect do
                  post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js
                end.to change(@book.evaluations, :count).by(1)
              end
            end
          end

          context 'book belongs to current user' do

            before { @book.update_attribute(:user_id, @user.id) }

            it 'renders nothing' do
              post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js

              expect(response.body).to be_blank
            end

            it 'does not create new evaluation' do
              expect do
                post :evaluate, book_id: @book.id, evaluation: @valid_atts, format: :js
              end.not_to change(Evaluation, :count)
            end
          end
        end

        context 'INVALID ATTRIBUTES' do

          before { @invalid_atts = { value: 0 } }

          context 'book does not belong to current user' do

            context 'evaluation exists' do

              before do
                @evaluation = FactoryGirl.create(:evaluation, value: 1, book_id: @book.id, user_id: @user.id)
              end

              it 'renders nothing' do
                post :evaluate, book_id: @book.id, evaluation: @invalid_atts, format: :js

                expect(response.body).to be_blank
              end

              it 'does not update evaluation' do
                post :evaluate, book_id: @book.id, evaluation: @invalid_atts, format: :js

                expect(@evaluation.reload.value).not_to eq @invalid_atts[:value]
              end
            end

            context 'evaluation does not exist' do

              it 'renders nothing' do
                post :evaluate, book_id: @book.id, evaluation: @invalid_atts, format: :js

                expect(response.body).to be_blank
              end

              it 'does not create new evaluation' do
                expect do
                  post :evaluate, book_id: @book.id, evaluation: @invalid_atts, format: :js
                end.not_to change(@book.evaluations, :count)
              end
            end
          end

          context 'book belongs to current user' do

            it 'renders nothing' do
              post :evaluate, book_id: @book.id, evaluation: @invalid_atts, format: :js

              expect(response.body).to be_blank
            end

            it 'does not create new evaluation' do
              expect do
                post :evaluate, book_id: @book.id, evaluation: @invalid_atts, format: :js
              end.not_to change(Evaluation, :count)
            end
          end
        end
      end
    end
  end
end
