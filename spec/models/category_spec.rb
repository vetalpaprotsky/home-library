require 'rails_helper'

describe Category do

  before { @category = FactoryGirl.create(:category) }
  subject { @category }

  it { should be_valid }
  it { should respond_to(:name) }
  it { should respond_to(:books) }

  describe "when name is not present" do
    before { @category.name = nil }
    it { should_not be_valid }
  end

  describe "default scope" do
    it "is order by name asc" do
      categories = [@category]
      5.times { categories << FactoryGirl.create(:category) }
      expect(Category.all).to eq categories.sort { |a, b|  a.name <=> b.name }
    end
  end
end
