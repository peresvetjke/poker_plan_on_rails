# frozen_string_literal: true

class RoundUserCreator
  def call(round_id:, user_id:)
    RoundUser.find_or_create_by(round_id:, user_id:)
  end
end
