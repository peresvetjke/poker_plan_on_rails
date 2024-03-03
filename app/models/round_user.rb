# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user

  after_create_commit -> { broadcast_prepend_to self.class.target(self), target: self.class.target(self) }
  after_destroy_commit -> { broadcast_remove_to self.class.target(self) }

  def self.target(round_user)
    "round_#{round_user.round_id}_round_users"
  end
end
