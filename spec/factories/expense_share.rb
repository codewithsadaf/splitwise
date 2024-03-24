# frozen_string_literal: true

FactoryBot.define do
  factory :expense_share do
    association :expense
    association :participant, factory: :user
    amount_owed { Faker::Commerce.price(range: 5..50.0) }
    category { %w[owed lent].sample }
    is_settled { false }
  end
end
