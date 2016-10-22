require 'rails_helper'

describe CommentsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:comment) { FactoryGirl.create(:comment, book_id: book.id, user_id: user.id) }
  let(:valid_comment_attrs) { FactoryGirl.attributes_for(:comment) }
  let(:invalid_comment_attrs) { FactoryGirl.attributes_for(:invalid_comment) }

  context 'SIGNED OUT' do

    describe 'GET #new' do

      it 'redirects to sign in page' do
        get :new, book_id: book.id

        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do

      it 'redirects to sign in page' do
        post :create, book_id: book.id, comment: valid_comment_attrs

        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do

      it 'redirects to sign in page' do
        get :edit, id: comment.id

        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PUT #update' do

      it 'redirects to sign in page' do
        put :update, id: comment.id, comment: valid_comment_attrs

        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do

      it 'redirects to sign in page' do
        delete :destroy, id: comment.id

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'SIGNED IN' do

    before do
      sign_in user
    end

    describe 'GET #new' do

      describe 'BEFORE ACTIONS' do

      end
    end

    describe 'POST #create' do

      describe 'BEFORE ACTIONS' do

      end

      context 'with valid attributes' do

      end

      context 'with invalid attributes' do

      end
    end

    describe 'GET #edit' do

      describe 'BEFORE ACTIONS' do

      end
    end

    describe 'PUT #update' do

      describe 'BEFORE ACTIONS' do

      end

      context 'with valid attributes' do

      end

      context 'with invalid attributes' do

      end
    end

    describe 'DELETE #destroy' do

      describe 'BEFORE ACTIONS' do

      end
    end
  end

  describe 'PRIVATE METHODS' do

    describe '#comment_params' do

    end

    describe '#find_book' do

    end

    describe '#find_comment' do

    end
  end
end
