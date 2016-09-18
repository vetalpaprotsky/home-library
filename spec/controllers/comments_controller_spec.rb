require 'rails_helper'

shared_examples "post create comment" do

  it "assigns comment to @comment that belongs to user" do
    post :create, book_id: @book.id, comment: @comment_attr
    expect(assigns(:comment).user).to eq @user
  end

  it "assigns comment to @comment that belongs to current book" do
    post :create, book_id: @book.id, comment: @comment_attr
    expect(assigns(:comment).book).to eq @book
  end

  it "assigns book to @book that owns comment" do
    post :create, book_id: @book.id, comment: @comment_attr
    expect(assigns(:book)).to eq @book
  end
end

shared_examples "put update comment" do
  it "assigns comment to @comment that belongs to user" do
    put :update, id: @comment.id, comment: @comment_attr
    expect(assigns(:comment).user).to eq @user
  end

  it "assigns comment to @comment that belongs to current book" do
    put :update, id: @comment.id, comment: @comment_attr
    expect(assigns(:comment).book).to eq @book
  end

  it "raises ActiveRecord::RecordNotFound if user does not own comment" do
    expect do
      put :update, id: FactoryGirl.create(:comment).id, comment: @comment_attr
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end

describe CommentsController do

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
        attrs = FactoryGirl.attributes_for(:comment)
        post :create, book_id: @book.id, comment: attrs
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET #edit" do

      it "redirects to sign in page" do
        comment = FactoryGirl.create(:comment, book_id: @book.id)
        get :edit, id: comment.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "PUT #update" do

      it "redirects to sign in page" do
        comment = FactoryGirl.create(:comment, book_id: @book.id)
        attrs = FactoryGirl.attributes_for(:comment)
        put :update, id: comment.id, comment: attrs
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "DELETE #destroy" do

      it "redirects to sign in page" do
        comment = FactoryGirl.create(:comment, book_id: @book.id)
        delete :destroy, id: comment.id
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

      it "builds a new comment that belongs to user" do
        get :new, book_id: @book.id
        expect(assigns(:comment).user).to eq @user
      end

      it "assigns book to @book that owns comment" do
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
          @comment_attr = FactoryGirl.attributes_for(:comment)
          @book = FactoryGirl.create(:book)
        end

        include_examples "post create comment"

        it "creates a new comment that belongs to user" do
          expect do
            post :create, book_id: @book.id, comment: @comment_attr
          end.to change(@user.comments, :count).by(1)
        end

        it "creates a new comment that belongs to current book" do
          expect do
            post :create, book_id: @book.id, comment: @comment_attr
          end.to change(@book.comments, :count).by(1)
        end

        it "redirects to book show" do
          post :create, book_id: @book.id, comment: @comment_attr
          expect(response).to redirect_to book_path(@book)
        end

        it "raises ActiveRecord::RecordNotFound if book does not exist and does not creates a new comment" do
          expect do
            post :create, book_id: 9999, comment: @comment_attr
          end.to raise_error(ActiveRecord::RecordNotFound).and change(Comment, :count).by(0)
        end
      end

      context "with invalid attributes" do

        before do
          @comment_attr = FactoryGirl.attributes_for(:invalid_comment)
          @book = FactoryGirl.create(:book)
        end

        include_examples "post create comment"

        it "does not create a new comment" do
          expect do
            post :create, book_id: @book.id, comment: @comment_attr
          end.not_to change(Comment, :count)
        end

        it "renders new template" do
          post :create, book_id: @book.id, comment: @comment_attr
          expect(response).to render_template :new
        end

        it "raises ActiveRecord::RecordNotFound if book does not exist" do
          expect do
            post :create, book_id: 9999, comment: @comment_attr
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "GET #edit" do

      before do
        @book = FactoryGirl.create(:book)
        @comment = FactoryGirl.create(:comment, book_id: @book.id, user_id: @user.id)
      end

      it "assigns comment to @comment that belongs to user" do
        get :edit, id: @comment.id
        expect(assigns(:comment).user).to eq @user
      end

      it "assigns comment to @comment that belongs to current book" do
        get :edit, id: @comment.id
        expect(assigns(:comment).book).to eq @book
      end

      it "renders edit template" do
        get :edit, id: @comment.id
        expect(response).to render_template :edit
      end

      it "raises ActiveRecord::RecordNotFound if user does not own comment" do
        expect do
          get :edit, id: FactoryGirl.create(:comment).id
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "PUT #update" do

      context "with valid attributes" do

        before do
          @book = FactoryGirl.create(:book)
          @comment = FactoryGirl.create(:comment, book_id: @book.id, user_id: @user.id)
          @comment_attr = FactoryGirl.attributes_for(:comment)
        end

        include_examples "put update comment"

        it "changes comment attributes" do
          put :update, id: @comment.id, comment: @comment_attr
          @comment.reload
          expect(@comment.text).to eq @comment_attr[:text]
        end

        it "redirects to book show" do
          put :update, id: @comment.id, comment: @comment_attr
          expect(response).to redirect_to book_path(@book)
        end
      end

      context "with invalid attributes" do

        before do
          @book = FactoryGirl.create(:book)
          @comment = FactoryGirl.create(:comment, book_id: @book.id, user_id: @user.id)
          @comment_attr = FactoryGirl.attributes_for(:invalid_comment)
        end

        include_examples "put update comment"

        it "does not change comment attributes" do
          put :update, id: @comment.id, comment: @comment_attr
          @comment.reload
          expect(@comment.text).not_to eq @comment_attr[:text]
        end

        it "renders edit template" do
          put :update, id: @comment.id, comment: @comment_attr
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do

      before do
        @book = FactoryGirl.create(:book)
        @comment = FactoryGirl.create(:comment, book_id: @book.id, user_id: @user.id)
      end

      it "assigns comment to @comment that belongs to user" do
        delete :destroy, id: @comment.id
        expect(assigns(:comment).user).to eq @user
      end

      it "assigns comment to @comment that belongs to current book" do
        delete :destroy, id: @comment.id
        expect(assigns(:comment).book).to eq @book
      end

      it "deletes comment for user" do
        expect do
          delete :destroy, id: @comment.id
        end.to change(@user.comments, :count).by(-1)
      end

      it "deletes comment for current book" do
        expect do
          delete :destroy, id: @comment.id
        end.to change(@book.comments, :count).by(-1)
      end

      it "redirects to book show" do
        delete :destroy, id: @comment.id
        expect(response).to redirect_to book_path(@book)
      end

      it "raises ActiveRecord::RecordNotFound and does not delete comment if user does not own it" do
        @comment = FactoryGirl.create(:comment)
        expect do
          delete :destroy, id: @comment.id
        end.to raise_error(ActiveRecord::RecordNotFound).and change(Comment, :count).by(0)
      end
    end
  end
end
