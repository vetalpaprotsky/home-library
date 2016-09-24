require 'rails_helper'

describe Evaluation do

  before { @evaluation = FactoryGirl.create(:evaluation) }
  subject { @evaluation }

  it { should respond_to(:value) }
  it { should respond_to(:user) }
  it { should respond_to(:book) }
  it { should be_valid }

  describe "when value is not preset" do
    before { @evaluation.value = nil }
    it { should_not be_valid }
  end

  describe "when value is less than 1" do
    before { @evaluation.value = 0 }
    it { should_not be_valid }
  end

  describe "when value is bigger than 5" do
    before { @evaluation.value = 6 }
    it { should_not be_valid }
  end

  describe "when user_id is not preset" do
    before { @evaluation.user_id = nil }
    it { should_not be_valid }
  end

  describe "when book_id is not preset" do
    before { @evaluation.book_id = nil }
    it { should_not be_valid }
  end
end
