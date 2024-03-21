# frozen_string_literal: true

class RoundUserComponent < ViewComponent::Base
  use_helpers :turbo_frame_tag

  def initialize(round_user:, user_voted:)
    @round_user = round_user
    @user_voted = user_voted
  end

end
