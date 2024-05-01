# frozen_string_literal: true

class RoundUserComponent < ApplicationComponent
  def initialize(round_user:, user_voted:)
    @round_user = round_user
    @user_voted = user_voted
    super
  end
end
