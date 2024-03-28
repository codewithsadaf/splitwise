# frozen_string_literal: true

class StaticController < ApplicationController
  before_action :set_friends_list
  before_action :set_user, only: [:person]

  def dashboard
    user_expense_client = UserExpenseStats.new(current_user)

    @user_expense_stats = user_expense_client.call
  end

  def person
    @expenses_paid_by_current_user = Expense.user_expenses(current_user, @user) || Exepnse.none
    @expenses_paid_by_friend = Expense.user_expenses(@user, current_user) || Exepnse.none
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: 'User not found'
  end

  def set_friends_list
    @friends = User.where.not(id: current_user.id)
  end
end
