require 'rails_helper'

describe Language do

  describe 'database columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:abbr).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:abbr) }
  end

  describe "default scope" do

    it "is order by abbr asc" do
      languages = [
        FactoryGirl.create(:language, abbr: 'ua'),
        FactoryGirl.create(:language, abbr: 'ru'),
        FactoryGirl.create(:language, abbr: 'ca')
      ]

      expect(Language.all).to eq languages.sort { |a, b|  a.abbr <=> b.abbr }
    end
  end
end
