require 'rails_helper'

describe EvaluationsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:evaluation) { FactoryGirl.create(:evaluation, value: 1, book_id: book.id, user_id: user.id) }
  let(:valid_attrs)   { { value: 5 } }
  let(:invalid_attrs) { { value: 0 } }

  shared_examples 'evaluation assigning' do |attrs|

    before { evaluation }

    it 'assings evaluation to @evaluation' do
      post :evaluate, book_id: book.id, evaluation: send(attrs), format: :js

      expect(assigns(:evaluation)).to eq evaluation
    end
  end

  shared_examples 'book assigning' do |attrs|

    it 'assings book to @book' do
      post :evaluate, book_id: book.id, evaluation: send(attrs), format: :js

      expect(assigns(:book)).to eq book
    end
  end

  shared_examples 'evaluation is not created' do |attrs|

    it 'does not create new evaluation' do
      expect do
        post :evaluate, book_id: book.id, evaluation: send(attrs), format: :js
      end.not_to change(Evaluation, :count)
    end
  end

  shared_examples 'nothing is rendered' do |attrs|

    it 'renders nothing' do
      post :evaluate, book_id: book.id, evaluation: send(attrs), format: :js

      expect(response.body).to be_blank
    end
  end

  shared_examples 'template is rendered' do |attrs|

    it 'renders evaluate template' do
      post :evaluate, book_id: book.id, evaluation: send(attrs), format: :js

      expect(response).to render_template 'evaluate'
    end
  end

  shared_examples 'new_evaluation assigning' do |attrs|

    it 'assigns true to @new_evaluation' do
      post :evaluate, book_id: book.id, evaluation: send(attrs), format: :js

      expect(assigns(:new_evaluation)).to eq true
    end
  end

  shared_examples 'valid evaluation' do

    it 'renders evaluate template' do
      post :evaluate, book_id: book.id, evaluation: valid_attrs, format: :js

      expect(response).to render_template 'evaluate'
    end

    it 'assigns average book evaluation to @average_evaluation' do
      post :evaluate, book_id: book.id, evaluation: valid_attrs, format: :js

      expect(assigns(:average_evaluation)).to eq book.average_evaluation
    end
  end

  context 'SIGN OUT' do

    describe 'POST evaluate' do

      it 'renders evaluations/authenticate_user template' do
        post :evaluate, book_id: book.id, evaluation: {}, format: :js

        expect(response).to render_template 'evaluations/authenticate_user'
      end
    end
  end

  context 'SIGN IN' do

    before do
      sign_in user
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

          include_examples 'book assigning', 'valid_attrs'

          context 'book does not belong to current user' do

            context 'evaluation exists' do

              include_examples 'evaluation assigning', 'valid_attrs'

              include_examples 'valid evaluation', 'valid_attrs'

              it 'updates evaluation' do
                post :evaluate, book_id: book.id, evaluation: valid_attrs, format: :js

                expect(evaluation.reload.value).to eq valid_attrs[:value]
              end
            end

            context 'evaluation does not exist' do

              it 'assings new evaluation to @evaluation' do
                post :evaluate, book_id: book.id, evaluation: valid_attrs, format: :js

                expect(assigns(:evaluation)).to eq user.evaluations.where(book_id: book.id).first
              end

              include_examples 'new_evaluation assigning', 'valid_attrs'

              include_examples 'valid evaluation', 'valid_attrs'

              it 'creates new evaluation for the user' do
                expect do
                  post :evaluate, book_id: book.id, evaluation: valid_attrs, format: :js
                end.to change(user.evaluations, :count).by(1)
              end

              it 'creates new evaluation for the book' do
                expect do
                  post :evaluate, book_id: book.id, evaluation: valid_attrs, format: :js
                end.to change(book.evaluations, :count).by(1)
              end
            end
          end

          context 'book belongs to current user' do

            before { book.update_attribute(:user_id, user.id) }

            include_examples 'nothing is rendered', 'valid_attrs'

            include_examples 'evaluation is not created', 'valid_attrs'
          end
        end

        context 'INVALID ATTRIBUTES' do

          include_examples 'book assigning', 'invalid_attrs'

          context 'book does not belong to current user' do

            context 'evaluation exists' do

              include_examples 'evaluation assigning', 'valid_attrs'

              include_examples 'nothing is rendered', 'invalid_attrs'

              it 'does not update evaluation' do
                post :evaluate, book_id: book.id, evaluation: invalid_attrs, format: :js

                expect(evaluation.reload.value).not_to eq evaluation: invalid_attrs[:value]
              end
            end

            context 'evaluation does not exist' do

              include_examples 'new_evaluation assigning', 'invalid_attrs'

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
