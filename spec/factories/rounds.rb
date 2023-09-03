# frozen_string_literal: true

FactoryBot.define do
  factory :round do
    sequence(:title) { |n| "round##{n}" }
  end
end
