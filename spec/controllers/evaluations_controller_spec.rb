require 'rails_helper'

describe EvaluationsController do

  let(:valid_attrs)   { { value: 5 } }
  let(:invalid_attrs) { { value: 0 } }

  shared_examples 'evaluation' do |attrs|

    before { @attrs = attrs == 'valid_attrs' ? valid_attrs : attrs == 'invalid_attrs' ? invalid_attrs : nil }

    it 'assings evaluation to @evaluation' do
      post :evaluate, book_id: @book.id, evaluation: @attrs, format: :js

      expect(assigns(:evaluation).id).to eq @evaluation.id
    end
  end

  shared_examples 'book' do |attrs|

    before { @attrs = attrs == 'valid_attrs' ? valid_attrs : attrs == 'invalid_attrs' ? invalid_attrs : nil }

    it 'assings book to @book' do
      post :evaluate, book_id: @book.id, evaluation: @attrs, format: :js

      expect(assigns(:book).id).to eq @book.id
    end
  end

  shared_examples 'evaluation is not created' do |attrs|

    before { @attrs = attrs == 'valid_attrs' ? valid_attrs : attrs == 'invalid_attrs' ? invalid_attrs : nil }

    it 'does not create new evaluation' do
      expect do
        post :evaluate, book_id: @book.id, evaluation: @attrs, format: :js
      end.not_to change(Evaluation, :count)
    end
  end

  shared_examples 'nothing is rendered' do |attrs|

    before { @attrs = attrs == 'valid_attrs' ? valid_attrs : attrs == 'invalid_attrs' ? invalid_attrs : nil }

    it 'renders nothing' do
      post :evaluate, book_id: @book.id, evaluation: @attrs, format: :js

      expect(response.body).to be_blank
    end
  end

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

          include_examples 'book', 'valid_attrs'

          context 'book does not belong to current user' do

            context 'evaluation exists' do

              before do
                @evaluation = FactoryGirl.create(:evaluation, value: 1, book_id: @book.id, user_id: @user.id)
              end

              include_examples 'evaluation', 'valid_attrs'

              include_examples 'nothing is rendered', 'valid_attrs'

              it 'updates evaluation' do
                post :evaluate, book_id: @book.id, evaluation: valid_attrs, format: :js

                expect(@evaluation.reload.value).to eq valid_attrs[:value]
              end
            end

            context 'evaluation does not exist' do

              it 'assings new evaluation to @evaluation' do
                post :evaluate, book_id: @book.id, evaluation: valid_attrs, format: :js

                expect(assigns(:evaluation).id).to eq @user.evaluations.where(book_id: @book.id).first.id
              end

              include_examples 'nothing is rendered', 'valid_attrs'

              it 'creates new evaluation that belongs to current user' do
                expect do
                  post :evaluate, book_id: @book.id, evaluation: valid_attrs, format: :js
                end.to change(@user.evaluations, :count).by(1)
              end

              it 'creates new evaluation that belongs to book' do
                expect do
                  post :evaluate, book_id: @book.id, evaluation: valid_attrs, format: :js
                end.to change(@book.evaluations, :count).by(1)
              end
            end
          end

          context 'book belongs to current user' do

            before { @book.update_attribute(:user_id, @user.id) }

            include_examples 'nothing is rendered', 'valid_attrs'

            include_examples 'evaluation is not created', 'valid_attrs'
          end
        end

        context 'INVALID ATTRIBUTES' do

          include_examples 'book', 'invalid_attrs'

          context 'book does not belong to current user' do

            context 'evaluation exists' do

              before do
                @evaluation = FactoryGirl.create(:evaluation, value: 1, book_id: @book.id, user_id: @user.id)
              end

              include_examples 'evaluation', 'valid_attrs'

              include_examples 'nothing is rendered', 'invalid_attrs'

              it 'does not update evaluation' do
                post :evaluate, book_id: @book.id, evaluation: invalid_attrs, format: :js

                expect(@evaluation.reload.value).not_to eq evaluation: invalid_attrs[:value]
              end
            end

            context 'evaluation does not exist' do

              include_examples 'nothing is rendered', 'invalid_attrs'

              include_examples 'evaluation is not created', 'invalid_attrs'
            end
          end

          context 'book belongs to current user' do

            include_examples 'nothing is rendered', 'invalid_attrs'

            include_examples 'evaluation is not created', 'invalid_attrs'
          end
        end
      end
    end
  end
end
