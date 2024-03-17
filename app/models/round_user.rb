# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user

  after_create_commit -> {
    user_voted = Estimation.exists?(user_id:, task: round.current_task)
    Broadcasts::UsersList.new.user_joined(round_user: self, user_voted:)
  }
  after_destroy_commit -> {
    Broadcasts::UsersList.new.user_left(round_user: self)
  }
end
