# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    after(:build, &:skip_confirmation_notification!)
    after(:create, &:confirm)
    id { 1 }
    email { 'abc@xyz.com' }
    username { 'TestUser' }
    account { 1 }
    password { Faker::Alphanumeric.alphanumeric(number: 8) }
  end
end
