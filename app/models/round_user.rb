# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user

  after_create_commit -> {
    user_voted = Estimation.exists?(user_id:, task: round.current_task)
    Views::UsersList.new(round_user: self, user:).user_joined(user_voted)

    # broadcast_prepend_later_to "round_#{self.round_id}",
    #   target: 'users_list',
    #   html: ::RoundUser::Component.new(round_user: self, user:, user_voted:)
  }
  after_destroy_commit -> {
    # broadcast_remove_to "round_#{round_id}", target: "round_user_#{id}"
    Views::UsersList.new(round_user: self, user:).user_left
  }

  # def self.target(round_user)
  #   "round_#{round_user.round_id}_round_users"
  # end
end
