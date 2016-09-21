require 'rails_helper'

describe Vote do

  before { @vote = FactoryGirl.create(:vote) }
  subject { @vote }

  it { should respond_to(:rating) }
  it { should respond_to(:user) }
  it { should respond_to(:book) }
  it { should be_valid }

  describe "when rating is not preset" do
    before { @vote.rating = nil }
    it { should_not be_valid }
  end

  describe "when rating is less than 1" do
    before { @vote.rating = 0 }
    it { should_not be_valid }
  end

  describe "when rating is bigger than 5" do
    before { @vote.rating = 6 }
    it { should_not be_valid }
  end

  describe "when user_id is not preset" do
    before { @vote.user_id = nil }
    it { should_not be_valid }
  end

  describe "when book_id is not preset" do
    before { @vote.book_id = nil }
    it { should_not be_valid }
  end
end
