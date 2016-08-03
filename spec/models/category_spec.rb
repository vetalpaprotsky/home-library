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

  it "returns categories sorted asc by name" do
    5.times { FactoryGirl.create(:category) }
    expect(Category.order_asc_by_name.map(&:name)).to eq(Category.order('name asc').map(&:name))
  end
end
