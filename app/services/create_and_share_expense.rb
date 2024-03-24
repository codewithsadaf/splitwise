# frozen_string_literal: true

class CreateAndShareExpense
  def initialize(params)
    @params = params
  end

  def call; end

  private

  attr_reader :params
end
