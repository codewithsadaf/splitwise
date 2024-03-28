# frozen_string_literal: true

class ExpenseShare < ApplicationRecord
  belongs_to :expense
  belongs_to :participant, class_name: 'User'

  validates :category, :amount_owed, presence: true

  enum category: { owed: 0, lent: 1 }
end
