require 'rails_helper'

describe Book do
  let(:book) { FactoryGirl.create(:book) }

  describe 'database columns' do
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:author).of_type(:string) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { is_expected.to have_db_column(:image).of_type(:string) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_and_belong_to_many(:categories) }
    it { is_expected.to have_many(:comments) }
    it { is_expected.to have_many(:evaluations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_length_of(:description).is_at_least(50) }
  end

  describe 'responses' do
    it { is_expected.to respond_to(:image_url) }
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:categories) }
    it { is_expected.to respond_to(:comments) }
    it { is_expected.to respond_to(:evaluations) }
  end

  describe 'instance methods' do
    describe '#average_evaluation' do
      context 'evaluations exist' do
        before { @evaluations = (1..5).map { FactoryGirl.create(:evaluation, book: book, value: rand(1..5)).value } }

        it 'returns average evaluation of the book' do
          average_evaluation = @evaluations.inject { |sum, evl| sum + evl }.to_f / @evaluations.count
          expect(book.average_evaluation).to eq average_evaluation
        end
      end

      context 'evaluations do not exist' do
        it 'returns 0' do
          expect(book.average_evaluation).to eq 0
        end
      end
    end
  end
end
