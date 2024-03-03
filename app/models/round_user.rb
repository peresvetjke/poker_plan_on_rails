# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user

  delegate :username, to: :user

  after_create_commit -> { Broadcasts::RoundUsersList.new.user_joined(round_user: self, user_voted: user_voted?) }
  after_destroy_commit -> { Broadcasts::RoundUsersList.new.user_left(round_user: self) }

  def user_voted?
    Estimation.exists?(user_id:, task: round.current_task)
  end
end
