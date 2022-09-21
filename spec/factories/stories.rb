# frozen_string_literal: true

FactoryBot.define do
  factory :story do
    id { 1 }
    content { 'Good Morning' }
    user
  end
  trait :invalid_story do
    id { 2 }
  end
end
