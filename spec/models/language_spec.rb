require 'rails_helper'

describe Language do

  before { @language = FactoryGirl.create(:language) }
  subject { @language }

  it { should respond_to :name }
  it { should respond_to :abbr }
  it { should be_valid }

  describe "when name is not present" do
    before { @language.name = nil }
    it { should_not be_valid }
  end

  describe "when abbr is not present" do
    before { @language.abbr = nil }
    it { should_not be_valid }
  end
end
