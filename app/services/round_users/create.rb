# frozen_string_literal: true

module RoundUsers
  class Create
    def initialize(user_id:, round_id:, listener: Listeners::Round.new)
      @user_id = user_id
      @round_id = round_id
      @listener = listener
    end

    def call
      round_user = RoundUser.find_or_create_by(user_id: @user_id, round_id: @round_id)
      @listener.user_joined(round_user:) unless round_user.persisted?
      round_user
    end
  end
end
