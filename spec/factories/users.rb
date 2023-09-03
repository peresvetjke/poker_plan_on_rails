# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    username { email.split('@').first }
    password { 'password' }
    is_moderator { false }
  end
end
