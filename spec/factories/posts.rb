# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    id { 1 }
    description { 'Life is beautiful' }
    user
  end
  trait :invalid_post do
    id { 5 }
  end
end
