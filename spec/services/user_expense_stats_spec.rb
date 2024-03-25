# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserExpenseStats do
  let(:user) { create(:user) }
  let(:participant) { create(:user) }

  describe '#call' do
    context 'when user has both lent and owed expenses' do
      before do
        2.times do
          expense = create(:expense, payor: user, amount: 100)
          create(:expense_share, expense: expense, participant: participant, amount_owed: 50, category: 'owed')
          create(:expense_share, expense: expense, participant: user, amount_owed: 50, category: 'lent')
        end

        expense = create(:expense, payor: participant, amount: 100)
        create(:expense_share, expense: expense, participant: user, amount_owed: 50, category: 'owed')
        create(:expense_share, expense: expense, participant: participant, amount_owed: 50, category: 'lent')
      end

      it 'calculates total amounts correctly' do
        service = described_class.new(user).call

        expect(service[:total_due_to_you]).to eq(100)
        expect(service[:total_you_owe]).to eq(50)
        expect(service[:total_balance]).to eq(50)
      end

      it 'fetches amounts owed by participants correctly' do
        service = described_class.new(user).call

        expected_result = [[participant.email, 100.to_d]]
        expect(service[:amounts_owed_by_participants]).to eq(expected_result)
      end

      it 'lists expenses correctly for which the user owes' do
        service = described_class.new(user).call

        expect(service[:expenses_you_owe_for].count).to eq(1)
        expect(service[:expenses_you_owe_for].first.expense.payor).to eq(participant)
      end
    end
  end
end
