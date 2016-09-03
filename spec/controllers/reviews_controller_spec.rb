require 'rails_helper'

shared_examples "assigning update" do
  it "assigns review to @review that belongs to user" do
    put :update, id: @review.id, review: @review_attr
    expect(assigns(:review).user).to eq @user
  end

  it "assigns review to @review that belongs to current book" do
    put :update, id: @review.id, review: @review_attr
    expect(assigns(:review).book).to eq @book
  end
end

shared_examples "assigning create" do

  it "assigns review to @review that belongs to user" do
    post :create, book_id: @book.id, review: @review_attr
    expect(assigns(:review).user).to eq @user
  end

  it "assigns review to @review that belongs to current book" do
    post :create, book_id: @book.id, review: @review_attr
    expect(assigns(:review).book).to eq @book
  end

  it "assigns book to @book that owns review" do
    post :create, book_id: @book.id, review: @review_attr
    expect(assigns(:book)).to eq @book
  end
end

describe ReviewsController do

  context "SIGNED OUT" do

    before { @book = FactoryGirl.create(:book) }

    describe "GET #new" do

      it "redirects to sign in page" do
        get :new, book_id: @book.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST #create" do

      it "redirects to sign in page" do
        attrs = FactoryGirl.attributes_for(:review)
        post :create, book_id: @book.id, review: attrs
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET #edit" do

      it "redirects to sign in page" do
        review = FactoryGirl.create(:review, book_id: @book.id)
        get :edit, id: review.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "PUT #update" do

      it "redirects to sign in page" do
        review = FactoryGirl.create(:review, book_id: @book.id)
        attrs = FactoryGirl.attributes_for(:review)
        put :update, id: review.id, review: attrs
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "DELETE #destroy" do

      it "redirects to sign in page" do
        review = FactoryGirl.create(:review, book_id: @book.id)
        delete :destroy, id: review.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context "SIGNED IN" do

    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    describe "GET #new" do

      before do
        @book = FactoryGirl.create(:book)
      end

      it "builds a new review that belongs to user" do
        get :new, book_id: @book.id
        expect(assigns(:review).user).to eq @user
      end

      it "assigns book to @book that owns review" do
        get :new, book_id: @book.id
        expect(assigns(:book)).to eq @book
      end

      it "renders the new template" do
        get :new, book_id: @book.id
        expect(response).to render_template :new
      end

      it "raises ActiveRecord::RecordNotFound if book does not exist" do
        expect do
          get :new, book_id: 9999
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "POST #create" do

      context "with valid attributes" do

        before do
          @review_attr = FactoryGirl.attributes_for(:review)
          @book = FactoryGirl.create(:book)
        end

        include_examples "assigning create"

        it "creates a new review that belongs to user" do
          expect do
            post :create, book_id: @book.id, review: @review_attr
          end.to change(@user.reviews, :count).by(1)
        end

        it "creates a new review that belongs to current book" do
          expect do
            post :create, book_id: @book.id, review: @review_attr
          end.to change(@book.reviews, :count).by(1)
        end

        it "redirects to book show" do
          post :create, book_id: @book.id, review: @review_attr
          expect(response).to redirect_to book_path(@book)
        end

        it "raises ActiveRecord::RecordNotFound if book does not exist and does not creates a new review" do
          expect do
            post :create, book_id: 9999, review: @review_attr
          end.to raise_error(ActiveRecord::RecordNotFound).and change(Review, :count).by(0)
        end
      end

      context "with invalid attributes" do

        before do
          @review_attr = FactoryGirl.attributes_for(:invalid_review)
          @book = FactoryGirl.create(:book)
        end

        include_examples "assigning create"

        it "does not create a new review" do
          expect do
            post :create, book_id: @book.id, review: @review_attr
          end.not_to change(Review, :count)
        end

        it "renders new template" do
          post :create, book_id: @book.id, review: @review_attr
          expect(response).to render_template :new
        end

        it "raises ActiveRecord::RecordNotFound if book does not exist" do
          expect do
            post :create, book_id: 9999, review: @review_attr
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "GET #edit" do

      before do
        @book = FactoryGirl.create(:book)
        @review = FactoryGirl.create(:review, book_id: @book.id, user_id: @user.id)
      end

      it "assigns review to @review that belongs to user" do
        get :edit, id: @review.id
        expect(assigns(:review).user).to eq @user
      end

      it "assigns review to @review that belongs to current book" do
        get :edit, id: @review.id
        expect(assigns(:review).book).to eq @book
      end

      it "renders the edit template" do
        get :edit, id: @review.id
        expect(response).to render_template :edit
      end

      it "raises ActiveRecord::RecordNotFound if user does not own review" do
        expect do
          get :edit, id: FactoryGirl.create(:review).id
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "PUT #update" do

      context "with valid attributes" do

        before do
          @book = FactoryGirl.create(:book)
          @review = FactoryGirl.create(:review, book_id: @book.id, user_id: @user.id)
          @review_attr = FactoryGirl.attributes_for(:review, rating: 2)
        end

        include_examples "assigning update"

        it "changes review attributes" do
          put :update, id: @review.id, review: @review_attr
          @review.reload
          expect(@review.comment).to eq @review_attr[:comment]
          expect(@review.rating).to eq @review_attr[:rating]
        end

        it "redirects to book show" do
          put :update, id: @review.id, review: @review_attr
          expect(response).to redirect_to book_path(@book)
        end

        it "raises ActiveRecord::RecordNotFound if user does not own review" do
          expect do
            put :update, id: FactoryGirl.create(:review).id, review: @review_attr
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "with invalid attributes" do

        before do
          @book = FactoryGirl.create(:book)
          @review = FactoryGirl.create(:review, book_id: @book.id, user_id: @user.id)
          @review_attr = FactoryGirl.attributes_for(:invalid_review)
        end

        include_examples "assigning update"

        it "does not change attributes" do
          put :update, id: @review.id, review: @review_attr
          @review.reload
          expect(@review.comment).not_to eq @review_attr[:comment]
          expect(@review.rating).not_to eq @review_attr[:rating]
        end

        it "renders edit template" do
          put :update, id: @review.id, review: @review_attr
          expect(response).to render_template :edit
        end

        it "raises ActiveRecord::RecordNotFound if user does not own review" do
          expect do
            put :update, id: FactoryGirl.create(:review).id, review: @review_attr
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "DELETE #destroy" do

      before do
        @book = FactoryGirl.create(:book)
        @review = FactoryGirl.create(:review, book_id: @book.id, user_id: @user.id)
      end

      it "assigns review to @review that belongs to user" do
        delete :destroy, id: @review.id
        expect(assigns(:review).user).to eq @user
      end

      it "assigns review to @review that belongs to current book" do
        delete :destroy, id: @review.id
        expect(assigns(:review).book).to eq @book
      end

      it "deletes review for user" do
        expect do
          delete :destroy, id: @review.id
        end.to change(@user.reviews, :count).by(-1)
      end

      it "deletes review for current book" do
        expect do
          delete :destroy, id: @review.id
        end.to change(@book.reviews, :count).by(-1)
      end

      it "redirects to book show" do
        delete :destroy, id: @review.id
        expect(response).to redirect_to book_path(@book)
      end

      it "raises ActiveRecord::RecordNotFound if user does not own review" do
        expect do
          delete :destroy, id: FactoryGirl.create(:review).id
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
