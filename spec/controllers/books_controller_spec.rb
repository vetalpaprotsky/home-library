require 'rails_helper'

shared_examples "get index" do

  before { FactoryGirl.create_list(:book, 13) }

  context "without page parameter" do

    context "without category" do

      it "populates an array of books to @books ordered by created_at desc" do
        get :index
        expect(assigns :books).to eq Book.order("created_at DESC").page(1).per(12)
      end

      it "populates @books array with 12 books " do
        get :index
        expect((assigns :books).count).to eq 12
      end
    end

    context "with category" do

      before do
        @category = FactoryGirl.create(:category, name: 'my_category')
        FactoryGirl.create_list(:book, 13, category_id: @category.id)
      end

      it "populates an array of books to @books ordered by created_at desc" do
        get :index, category: @category.name
        expect(assigns :books).to eq Book.where(category_id: @category.id).order("created_at DESC").page(1).per(12)
      end

      it "populates @books array with 12 books" do
        get :index, category: @category.name
        expect((assigns :books).count).to eq 12
      end
    end
  end

  context "with page parameter 2" do

    before { @page = 2 }

    context "without category" do

      it "populates an array of books to @books ordered by created_at desc" do
        get :index, page: @page
        expect(assigns :books).to eq Book.order("created_at DESC").page(@page).per(12)
      end

      it "populates @books array with 1 book" do
        get :index, page: @page
        expect((assigns :books).count).to eq 1
      end
    end

    context "with category" do

      before do
        @category = FactoryGirl.create(:category, name: 'my_category')
        FactoryGirl.create_list(:book, 13, category_id: @category.id)
      end

      it "populates an array of books to @books ordered by created_at desc" do
        get :index, page: @page, category: @category.name
        expect(assigns :books).to eq Book.where(category_id: @category.id).order("created_at DESC").page(@page).per(12)
      end

      it "populates @books array with 1 book" do
        get :index, page: @page, category: @category.name
        expect((assigns :books).count).to eq 1
      end
    end
  end

  it "renders index template" do
    get :index
    expect(response).to render_template :index
  end
end

shared_examples "get show book" do

  before do
    @book = FactoryGirl.create(:book)
    FactoryGirl.create_list(:comment, 11, book: @book)
  end

  context "without page parameter" do

    it "populates an array of comments to @comments which belongs to @book" do
      get :show, id: @book.id
      expect(assigns :comments).to eq @book.comments.page(1).per(10)
    end

    it "populates @comments array with 10 comments" do
      get :show, id: @book.id
      expect((assigns :comments).count).to eq 10
    end
  end

  context "with page parameter 2" do

    before { @page = 2 }

    it "populates an array of comments to @comments which belongs to @book" do
      get :show, id: @book.id, page: @page
      expect(assigns :comments).to eq @book.comments.page(@page).per(10)
    end

    it "populates @comments array with 1 comment" do
      get :show, id: @book.id, page: @page
      expect((assigns :comments).count).to eq 1
    end
  end

  it "assigns book to @book" do
    get :show, id: @book.id
    expect(assigns :book).to eq @book
  end

  it "assigns avarege rating of the book to @average_rating"

  it "renders show template" do
    get :show, id: @book.id
    expect(response).to render_template :show
  end

  it "raises ActiveRecord::RecordNotFound if book does not exist" do
    expect do
      get :show, id: 9999
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end

shared_examples "post create book" do

  it "assigns book to @book that belongs to user" do
    post :create, book: @book_attr
    expect(assigns(:book).user).to eq @user
  end
end

shared_examples "put update" do

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

      include_examples "get index"
    end

    describe "GET #show" do

      include_examples "get show book"
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

      include_examples "get index"
    end

    describe "GET #show" do

      include_examples "get show book"
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

    describe "POST #create" do

      context "with valid attributes" do

        before do
          @book_attr = FactoryGirl.attributes_for(:book,
                       category_id: FactoryGirl.create(:category).id)
        end

        include_examples "post create book"

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

        include_examples "post create book"

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

    describe "GET #edit" do

      before do
        @book = FactoryGirl.create(:book, user: @user)
      end

      it "assigns book to @book that belongs to user" do
        get :edit, id: @book.id
        expect(assigns(:book).user).to eq @book.user
      end

      it "renders edit template" do
        get :edit, id: @book.id
        expect(response).to render_template :edit
      end

      it "raises ActiveRecord::RecordNotFound if user does not own book" do
        expect do
          get :edit, id: FactoryGirl.create(:book)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "PUT #update" do

      context "with valid attributes" do

        before do
          @book = FactoryGirl.create(:book, user_id: @user.id)
          @book_attr = FactoryGirl.attributes_for(:book,
                       category_id: FactoryGirl.create(:category).id)
        end

        include_examples "put update"

        it "changes book attributes" do
          put :update, id: @book.id, book: @book_attr
          @book.reload
          expect(@book.title).to eq @book_attr[:title]
          expect(@book.description).to eq @book_attr[:description]
          expect(@book.author).to eq @book_attr[:author]
          expect(@book.category_id).to eq @book_attr[:category_id]
        end

        it "redirects to book show" do
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

        include_examples "put update"

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

      it "assigns book to @book that belongs to user" do
        delete :destroy, id: @book.id
        expect(assigns(:book).user).to eq @user
      end

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
