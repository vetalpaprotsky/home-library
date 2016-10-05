require 'rails_helper'

describe Category do

  describe 'database columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:books) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "default scope" do

    it "is order by name asc" do
      categories = FactoryGirl.create_list(:category, 5)

      expect(Category.all).to eq categories.sort { |a, b|  a.name <=> b.name }
    end
  end
end
