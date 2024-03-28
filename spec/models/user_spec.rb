# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:expenses_paid).dependent(:destroy) }
    it { is_expected.to have_many(:expense_shares).dependent(:destroy) }
    it { is_expected.to have_many(:shared_expenses).through(:expense_shares) }
  end
end
