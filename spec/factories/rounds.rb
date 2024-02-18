# frozen_string_literal: true

FactoryBot.define do
  factory :round do
    sequence(:title) { |n| "round##{n}" }

    trait :with_tasks do
      after(:build) do |round|
        create_list(:task, 2, round:)
      end
    end
  end
end
