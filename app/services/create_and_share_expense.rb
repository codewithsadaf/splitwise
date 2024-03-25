# frozen_string_literal: true

class CreateAndShareExpense
  def initialize(params)
    @params = params
    @payor_id = params.dig(:expense, :payor_id)
    @participant_id_params = params.dig(:expense, :participant_ids)
    @amount = params.dig(:expense, :amount)
  end

  def call
    validate_params!
    create_expense
  rescue ActiveRecord::RecordInvalid => e
    OpenStruct.new(success?: false, expense: nil, error: e.message)
  end

  private

  attr_reader :payor_id, :params, :participant_id_params, :amount

  def validate_params!
    raise ArgumentError, 'Payor ID cannot be blank' if payor_id.blank?
    raise ArgumentError, 'Participants cannot be empty' if participant_id_params.empty?
    raise ArgumentError, 'Amount cannot be blank' if amount.blank?
  end

  def create_expense
    Expense.transaction do
      expense = Expense.create!(expense_params)
      divide_expense_among_participants(expense)
      OpenStruct.new(success?: true, expense: expense, error: nil)
    end
  end

  def expense_params
    params.require(:expense).permit(:payor_id, :amount, :description, :date)
  end

  def participant_ids
    @participant_ids ||= ([participant_id_params] + [payor_id]).flatten.uniq.reject(&:blank?)
  end

  def divide_expense_among_participants(expense)
    total_participants = participant_ids.size
    base_share_amount = (expense.amount.to_f / total_participants).floor(2)
    total_divided = base_share_amount * (total_participants - 1)
    first_participant_share = (expense.amount - total_divided).round(2)

    participant_ids.each_with_index do |participant_id, index|
      share_amount = index.zero? ? first_participant_share : base_share_amount

      ExpenseShare.create!(
        expense: expense,
        participant_id: participant_id,
        amount_owed: share_amount,
        category: participant_id.to_s == payor_id.to_s ? 'lent' : 'owed'
      )
    end
  end

  def calculate_share_amount(total_amount, num_participants)
    (total_amount.to_f / num_participants).round(2)
  end
end
