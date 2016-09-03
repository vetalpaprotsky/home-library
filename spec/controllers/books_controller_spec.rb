require 'rails_helper'

shared_examples "get_index" do

  it "populates an array of books ordered by created_at desc" do
    5.times { FactoryGirl.create(:book) }
    get :index
    expect(assigns :books).to eq Book.order("created_at DESC")
  end

  it "populates an array of books ordered by created_at desc with certain category" do
    category = FactoryGirl.create(:category)
    3.times do
      FactoryGirl.create(:book)
      FactoryGirl.create(:book, category_id: category.id)
    end
    get :index, category: category.name
    expect(assigns :books).to eq Book.where(category_id: category.id).order("created_at DESC")
  end

  it "renders index template" do
    get :index
    expect(response).to render_template :index
  end
end

shared_examples "get_show" do

  before do
    @book = FactoryGirl.create(:book)
    get :show, id: @book.id
  end

  it "assigns book to @book" do
    expect(assigns :book).to eq @book
  end

  it "renders show template" do
    expect(response).to render_template :show
  end

  it "raises ActiveRecord::RecordNotFound if book does not exist" do
    expect do
      get :show, id: 9999
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end

shared_examples "put_update" do

  it "assigns book to @book that belongs to user" do
    put :update, id: @book.id, book: @book_attr
    expect((assigns :book).user).to eq @book.user
  end

  it "raises ActiveRecord::RecordNotFound if user does not own book" do
    expect do
      put :update, id: FactoryGirl.create(:book).id, book: @book_attr
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end

describe BooksController do

  context "SIGNED OUT" do

    describe "GET #index" do

      include_examples "get_index"
    end

    describe "GET #show" do

      include_examples "get_show"
    end

    describe "GET #new" do

      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do

      it "redirects to sign in page" do
        get :edit, id: FactoryGirl.create(:book).id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do

      it "redirects to sign in page" do
        post :create, book: FactoryGirl.attributes_for(:book)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PUT #update" do

      it "redirects to sign in page" do
        book = FactoryGirl.create(:book)
        book_attr = FactoryGirl.attributes_for(:book)
        put :update, id: book.id, book: book_attr
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #destroy" do

      it "redirects to sign in page" do
        book = FactoryGirl.create(:book)
        delete :destroy, id: book.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "SIGNED IN" do

    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET #index" do

      include_examples "get_index"
    end

    describe "GET #show" do

      include_examples "get_show"
    end

    describe "GET #new" do

      before { get :new }

      it "builds a new book that belongs to user" do
        expect(assigns(:book).user).to eq @user
      end

      it "renders new template" do
        expect(response).to render_template :new
      end
    end

    describe "GET #edit" do

      before do
        @book = FactoryGirl.create(:book, user: @user)
        get :edit, id: @book.id
      end

      it "assigns book to @book that belongs to user" do
        expect(assigns(:book).user).to eq @book.user
      end

      it "renders edit template" do
        expect(response).to render_template :edit
      end

      it "raises ActiveRecord::RecordNotFound if user does not own book" do
        expect do
          get :edit, id: FactoryGirl.create(:book)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "POST #create" do

      context "with valid attributes" do

        before do
          @book_attr = FactoryGirl.attributes_for(:book,
                       category_id: FactoryGirl.create(:category).id)
        end

        it "creates a new book that belongs to user" do
          expect do
            post :create, book: @book_attr
          end.to change(@user.books, :count).by(1)
        end

        it "redirects to index" do
          post :create, book: @book_attr
          expect(response).to redirect_to :books
        end
      end

      context "with invalid attributes" do

        before do
          @book_attr = FactoryGirl.attributes_for(:invalid_book,
                       category_id: FactoryGirl.create(:category).id)
        end

        it "does not create a new book" do
          expect do
            post :create, book: @book_attr
          end.to_not change(@user.books, :count)
        end

        it "renders new template" do
          post :create, book: @book_attr
          expect(response).to render_template :new
        end
      end
    end

    describe "PUT #update" do

      context "with valid attributes" do

        before do
          @book = FactoryGirl.create(:book, user_id: @user.id)
          @book_attr = FactoryGirl.attributes_for(:book,
                       category_id: FactoryGirl.create(:category).id)
        end

        include_examples "put_update"

        it "changes book attributes" do
          put :update, id: @book.id, book: @book_attr
          @book.reload
          expect(@book.title).to eq @book_attr[:title]
          expect(@book.description).to eq @book_attr[:description]
          expect(@book.author).to eq @book_attr[:author]
          expect(@book.category_id).to eq @book_attr[:category_id]
        end

        it "redirects to show template of updated book" do
          put :update, id: @book.id, book: @book_attr
          expect(response).to redirect_to(book_path @book)
        end
      end

      context "with invalid attributes" do

        before do
          @book = FactoryGirl.create(:book, user_id: @user.id)
          @book_attr = FactoryGirl.attributes_for(:invalid_book,
                       category_id: FactoryGirl.create(:category).id)
        end

        include_examples "put_update"

        it "does not change book attributes" do
          put :update, id: @book.id, book: @book_attr
          @book.reload
          expect(@book.title).to_not eq @book_attr[:title]
          expect(@book.description).to_not eq @book_attr[:description]
          expect(@book.author).to_not eq @book_attr[:author]
          expect(@book.category_id).to_not eq @book_attr[:category_id]
        end

        it "renders edit template" do
          put :update, id: @book.id, book: @book_attr
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do

      before { @book = FactoryGirl.create(:book, user: @user) }

      it "deletes book" do
        expect do
          delete :destroy, id: @book.id
        end.to change(@user.books, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: @book.id
        expect(response).to redirect_to :books
      end

      it "raises ActiveRecord::RecordNotFound and does not delete book if user does not own it" do
        @book = FactoryGirl.create(:book)
        expect do
          delete :destroy, id: @book.id
        end.to raise_error(ActiveRecord::RecordNotFound).and change(Book, :count).by(0)
      end
    end
  end
end
