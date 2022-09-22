# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    statement { Faker::Lorem.sentence }
    post
    user
  end
  trait :invalid_text do
    statement { 'Hi' }
  end
end
