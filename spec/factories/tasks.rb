# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    round
    sequence(:title) { |n| "task##{n}" }
    state { :idle }
  end
end
