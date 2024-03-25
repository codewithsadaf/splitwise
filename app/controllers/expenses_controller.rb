# frozen_string_literal: true

class ExpensesController < ApplicationController
  def new
    @expense = Expense.new
    @users = User.all
  end

  def create
    service = CreateAndShareExpense.new(params)
    result = service.call

    if result.success?
      redirect_back(fallback_location: root_path, notice: 'Expense was successfully created.')
    else
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:payor_id, :amount, :description, :date)
  end
end
