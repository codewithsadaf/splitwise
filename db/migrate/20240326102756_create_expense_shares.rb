# frozen_string_literal: true

class CreateExpenseShares < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_shares do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: { to_table: :users }
      t.decimal :amount_owed, precision: 10, scale: 2, null: false, default: 0.00
      t.string :category, null: false, default: 'owed'
      t.boolean :is_settled, default: false

      t.timestamps
    end
  end
end
