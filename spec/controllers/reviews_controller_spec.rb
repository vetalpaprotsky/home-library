require 'rails_helper'

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
        get :edit, book_id: @book.id, id: review.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "PUT #update" do

      it "redirects to sign in page" do
        review = FactoryGirl.create(:review, book_id: @book.id)
        attrs = FactoryGirl.attributes_for(:review)
        put :update, book_id: @book.id, id: review.id, review: attrs
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "DELETE #destroy" do

      it "redirects to sign in page" do
        review = FactoryGirl.create(:review, book_id: @book.id)
        delete :destroy, book_id: @book.id, id: review.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context "SIGNED IN" do

    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

  end
end
