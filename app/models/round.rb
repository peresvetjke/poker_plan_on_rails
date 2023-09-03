# frozen_string_literal: true

class Round < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
