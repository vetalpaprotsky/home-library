require 'rails_helper'

describe User do

  describe 'database columns' do
    it { is_expected.to have_db_column(:id).of_type(:integer) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:books) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:evaluations) }
  end

  describe 'validations' do
    it { is_expected.to allow_value('for@bar.com').for(:email) }
    it { is_expected.not_to allow_value('for@barcom').for(:email) }
    it { is_expected.not_to allow_value('forbar.com').for(:email) }
    it { is_expected.not_to allow_value('').for(:email) }
  end
end
