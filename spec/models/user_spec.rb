require 'rails_helper'

describe User do
  describe 'database columns' do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
    it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
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
    it { is_expected.not_to allow_value('forbarcom').for(:email) }
    it { is_expected.not_to allow_value('').for(:email) }
  end

  describe 'responses' do
    it { is_expected.to respond_to(:books) }
    it { is_expected.to respond_to(:comments) }
    it { is_expected.to respond_to(:evaluations) }
  end
end
