# frozen_string_literal: true

class Task < ApplicationRecord
  enum :state, %i[idle ongoing finished]

  belongs_to :round
  has_many :estimations, dependent: :destroy

  validates :title, presence: true

  broadcasts_to ->(task) { [task.round, :tasks] }, inserts_by: :prepend,
                                                   target: ->(task) { "round_#{task.round_id}_tasks" }
end
