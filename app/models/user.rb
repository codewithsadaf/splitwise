# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses_paid, foreign_key: 'payor_id', class_name: 'Expense', dependent: :destroy
  has_many :expense_shares, foreign_key: 'participant_id', dependent: :destroy
  has_many :shared_expenses, through: :expense_shares, source: :expense
end
