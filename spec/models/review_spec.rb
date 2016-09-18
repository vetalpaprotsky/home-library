require 'rails_helper'

describe Comment do

  before { @comment = FactoryGirl.create(:comment) }
  subject { @comment }

  it { should respond_to(:text) }
  it { should respond_to(:book) }
  it { should respond_to(:user) }
  it { should be_valid }

  describe "when text is not present" do
    before { @comment.text = nil }
    it { should_not be_valid }
  end

  describe "when book_id is not present" do
    before { @comment.book_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @comment.user_id = nil }
    it { should_not be_valid }
  end
end
