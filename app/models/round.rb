# frozen_string_literal: true

class Round < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :tasks, dependent: :destroy
  has_many :round_users, dependent: :destroy
  has_many :users, through: :round_users
  # has_one :current_task, -> (round) { round.tasks.ongoing.first }, class_name: 'Task'

  scope :ordered, -> { order(id: :desc) }

  broadcasts_to ->(_round) { 'rounds' }, inserts_by: :prepend

  def current_task
    tasks.ongoing.first
  end
end
