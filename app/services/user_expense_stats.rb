# frozen_string_literal: true

class UserExpenseStats
  def initialize(user)
    @user = user
  end

  def call; end

  private

  attr_reader :user
end
