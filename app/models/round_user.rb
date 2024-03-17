# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user

  after_create_commit -> {
    user_voted = Estimation.exists?(user_id:, task: round.current_task)
    Views::UsersList.new(round_user: self, user:).user_joined(user_voted)
  }
  after_destroy_commit -> {
    Views::UsersList.new(round_user: self, user:).user_left
  }
end
