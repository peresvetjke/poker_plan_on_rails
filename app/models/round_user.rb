# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user

  delegate :username, to: :user

  def user_voted?
    Estimation.exists?(user_id:, task: round.current_task)
  end
end
