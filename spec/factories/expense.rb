# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    association :payor, factory: :user
    amount { Faker::Commerce.price(range: 10..100.0) }
    description { Faker::Commerce.product_name }
    date { Date.today }
  end
end
