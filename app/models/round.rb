# frozen_string_literal: true

class Round < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :tasks, dependent: :destroy
  has_many :round_users, dependent: :destroy
  has_many :users, through: :round_users

  has_one :current_task, ->(round) { where(round_id: round.id, state: 'ongoing') }, class_name: 'Task',
                                                                                    dependent: :destroy,
                                                                                    inverse_of: :round

  broadcasts_to ->(_) { 'rounds' }, inserts_by: :prepend
end
