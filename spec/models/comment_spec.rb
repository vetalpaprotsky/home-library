require 'rails_helper'

describe Comment do
  describe 'database columns' do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:text).of_type(:text) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:book_id).of_type(:integer) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:book_id) }
  end

  describe 'responses' do
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:book) }
  end

  describe "default scope" do
    it "is order by created_at desc" do
      comments = FactoryGirl.create_list(:comment, 5)
      expect(Comment.all).to eq comments.sort { |a, b|  b.created_at <=> a.created_at }
    end
  end
end
