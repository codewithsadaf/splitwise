# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :payor, class_name: 'User', foreign_key: 'payor_id'

  has_many :expense_shares, dependent: :destroy
  has_many :participants, through: :expense_shares

  validates :amount, presence: true

  after_initialize :set_default_date, if: :new_record?

  scope :user_expenses, lambda { |payor, participant|
    where(payor: payor)
      .joins(:expense_shares)
      .where(expense_shares: { participant: participant })
  }

  private

  def set_default_date
    self.date ||= Date.today
  end
end
