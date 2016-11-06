require 'rails_helper'

describe Admin do

  describe 'database columns' do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }
  end

  describe 'validations' do
    it { is_expected.to allow_value('for@bar.com').for(:email) }
    it { is_expected.not_to allow_value('for@barcom').for(:email) }
    it { is_expected.not_to allow_value('forbar.com').for(:email) }
    it { is_expected.not_to allow_value('forbarcom').for(:email) }
    it { is_expected.not_to allow_value('').for(:email) }
  end
end
