# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    after(:build, &:skip_confirmation_notification!)
    after(:create, &:confirm)
    id { 1 }
    email { Faker::Internet.email }
    username { 'TestUser' }
    account { 1 }
    password { Faker::Alphanumeric.alphanumeric(number: 8) }
  end
  trait :unauthorized do
    id { 2 }
    username { 'UnAuthorized' }
    email { Faker::Internet.email }
    password { Faker::Alphanumeric.alphanumeric(number: 8) }
  end
  trait :valid_username do
    username { 'ValidUser' }
  end
  trait :invalid_username do
    username { 'Invalid User_123' }
  end
end
