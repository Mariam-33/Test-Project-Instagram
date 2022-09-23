# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    statement { Faker::Lorem.sentence }
    post
    user
  end
  trait :invalid_text_min do
    statement { Faker::Lorem.characters(number: 2) }
  end
  trait :invalid_text_max do
    statement { Faker::Lorem.characters(number: 501) }
  end
end
