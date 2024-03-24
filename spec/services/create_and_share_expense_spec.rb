# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAndShareExpense do
  let!(:payor) { create(:user) }
  let!(:participant1) { create(:user) }
  let!(:participant2) { create(:user) }

  let(:valid_params) do
    {
      payor_id: payor.id,
      participant_ids: [participant1.id, participant2.id, ''],
      amount: 100.0,
      description: 'Dinner',
      date: Date.today
    }
  end

  describe '#call' do
    context 'with valid parameters' do
      context 'with even number of participants' do
        it 'creates an expense and divides it equally' do
          service = CreateAndShareExpense.new(ActionController::Parameters.new(expense: valid_params))

          result = service.call

          expect(result.success?).to be true
          expect(result.expense).to be_persisted

          expense_shares = result.expense.expense_shares

          expect(expense_shares.owed.size).to eq(2)
          expect(expense_shares.lent.size).to eq(1)
          expect(expense_shares.pluck(:amount_owed).map(&:to_f)).to eq([33.34, 33.33, 33.33])
        end
      end

      context 'with odd number of participants' do
        it 'creates an expense and with the first participant having slightly larger share' do
          service = CreateAndShareExpense.new(ActionController::Parameters.new(expense: valid_params))

          result = service.call

          expect(result.success?).to be true
          expect(result.expense).to be_persisted

          expense_shares = result.expense.expense_shares

          expect(expense_shares.owed.size).to eq(2)
          expect(expense_shares.lent.size).to eq(1)
          expect(expense_shares.pluck(:amount_owed).map(&:to_f)).to eq([33.34, 33.33, 33.33])
        end
      end
    end

    context 'with invalid parameters' do
      it 'fails when the payor ID is missing' do
        invalid_params = valid_params.except(:payor_id)
        service = CreateAndShareExpense.new(ActionController::Parameters.new(expense: invalid_params))

        expect { service.call }.to raise_error(ArgumentError, 'Payor ID cannot be blank')
      end

      it 'fails when the amount is missing' do
        invalid_params = valid_params.except(:amount)
        service = CreateAndShareExpense.new(ActionController::Parameters.new(expense: invalid_params))

        expect { service.call }.to raise_error(ArgumentError, 'Amount cannot be blank')
      end

      it 'fails when participants are empty' do
        invalid_params = valid_params.merge(participant_ids: [])
        service = CreateAndShareExpense.new(ActionController::Parameters.new(expense: invalid_params))

        expect { service.call }.to raise_error(ArgumentError, 'Participants cannot be empty')
      end
    end
  end
end
