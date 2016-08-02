require 'rails_helper'

describe Book do

  before { @book = FactoryGirl.create(:book) }
  subject { @book }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:author) }
  it { should respond_to(:user) }
  it { should be_valid }

  describe "when title is not present" do
    before { @book.title = nil }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { @book.description = nil }
    it { should_not be_valid }
  end

  describe "when author is not present" do
    before { @book.author = nil }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @book.user_id = nil }
    it { should_not be_valid }
  end
end
