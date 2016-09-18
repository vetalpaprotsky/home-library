require 'rails_helper'

describe Review do

  before { @review = FactoryGirl.create(:review) }
  subject { @review }

  it { should respond_to(:comment) }
  it { should respond_to(:book) }
  it { should respond_to(:user) }
  it { should be_valid }

  describe "when comment is not present" do
    before { @review.comment = nil }
    it { should_not be_valid }
  end

  describe "when book_id is not present" do
    before { @review.book_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @review.user_id = nil }
    it { should_not be_valid }
  end
end
