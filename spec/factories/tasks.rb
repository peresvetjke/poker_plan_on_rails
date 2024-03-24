# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    round
    sequence(:title) { |n| "task##{n}" }
    state { :idle }

    trait :idle do
      state { :ongoing }
    end

    trait :ongoing do
      state { :ongoing }
    end

    trait :finished do
      state { :finished }
    end
  end
end
