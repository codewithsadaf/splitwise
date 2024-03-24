# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:payor).class_name('User') }
    it { is_expected.to have_many(:expense_shares).dependent(:destroy) }
    it { is_expected.to have_many(:participants).through(:expense_shares) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe '#set_default_date' do
    subject { described_class.new }

    it 'sets the date to today if not provided' do
      expect(subject.date).to eq(Date.today)
    end
  end
end
