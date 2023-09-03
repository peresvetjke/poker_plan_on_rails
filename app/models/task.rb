# frozen_string_literal: true

class Task < ApplicationRecord
  enum :state, %i[idle ongoing finished]

  belongs_to :round

  validates :title, presence: true
end
