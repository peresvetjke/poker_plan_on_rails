# frozen_string_literal: true

FactoryBot.define do
  factory :estimation do
    user
    task
    value { (1..3).to_a.sample }
  end
end
