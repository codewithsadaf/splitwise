# frozen_string_literal: true

class UserExpenseStats
  def initialize(user)
    @user = user
  end

  def call
    {
      total_due_to_you: total_due_to_you,
      total_you_owe: total_you_owe,
      total_balance: total_balance,
      amounts_owed_by_participants: amounts_owed_by_participants,
      expenses_you_owe_for: expenses_you_owe_for
    }
  end

  private

  attr_reader :user

  def total_due_to_you
    user_expenses = Expense.where(payor: user)

    ExpenseShare.where(expense: user_expenses, category: 'owed').sum(:amount_owed)
  end

  def total_you_owe
    ExpenseShare.where(participant: user, category: 'owed').sum(:amount_owed)
  end

  def total_balance
    total_due_to_you - total_you_owe
  end

  def amounts_owed_by_participants
    expenses = Expense.where(payor: user)

    ExpenseShare
      .where(expense: expenses, category: 'owed')
      .joins(:participant)
      .group('users.email')
      .pluck('users.email', 'SUM(expense_shares.amount_owed)')
  end

  def expenses_you_owe_for
    user.expense_shares.where(category: 'owed').includes(:expense)
  end
end
