require 'rails_helper'

describe BooksController do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book, user_id: user.id) }
  let(:evaluation) { FactoryGirl.create(:evaluation, book_id: book.id, user_id: user.id) }
  let(:valid_book_attrs) { FactoryGirl.attributes_for(:book, category_id: FactoryGirl.create(:category).id) }
  let(:invalid_book_attrs) { FactoryGirl.attributes_for(:invalid_book, category_id: FactoryGirl.create(:category).id) }

  shared_examples 'get index' do
    describe 'BEFORE ACTIONS' do
    end
  end

  shared_examples 'get show' do
    describe 'BEFORE ACTIONS' do
    end
  end

  context 'SIGNED OUT' do
    describe 'GET #index' do
      include_examples 'get index'
    end

    describe 'GET #show' do
      include_examples 'get show'
    end

    describe 'GET #new' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET #edit' do
      it 'redirects to sign in page' do
        get :edit, id: book.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      it 'redirects to sign in page' do
        post :create, book: valid_book_attrs
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT #update' do
      it 'redirects to sign in page' do
        put :update, id: book.id, book: valid_book_attrs
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to sign in page' do
        delete :destroy, id: book.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context 'SIGNED IN' do

    before do
      sign_in user
    end

    describe 'GET #index' do
      include_examples 'get index'
    end

    describe 'GET #index' do
      include_examples 'get index'
    end

    describe 'GET #show' do
      include_examples 'get show'

      context 'evaluation for the book exists' do
        before { evaluation }

        it 'assigns evaluation to @evaluation' do
          get :show, id: book.id
          expect(assigns(:evaluation)).to eq evaluation
        end
      end
    end

    describe 'GET #new' do
      describe 'BEFORE ACTIONS' do
      end

      it 'builds a new book for the user' do
        get :new
        expect(assigns(:book).user).to eq user
      end

      it 'renders new template' do
        get :new
        expect(response).to render_template :new
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
    describe '#book_params' do
    end

    describe '#find_book' do
    end

    describe '#find_book_for_current_user' do
    end
  end
end
