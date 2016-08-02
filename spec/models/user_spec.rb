require 'rails_helper'

describe User do

  before { @user = FactoryGirl.create(:user) }
  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:books) }

  describe "when email is not present" do
    before { @user.email = nil }
    it { should_not be_valid }
  end
end
