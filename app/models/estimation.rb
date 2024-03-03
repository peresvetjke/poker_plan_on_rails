# frozen_string_literal: true

class Estimation < ApplicationRecord
  OPTIONS = [1, 2, 3, 5, 8].freeze

  belongs_to :user
  belongs_to :task

  validates :value, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
