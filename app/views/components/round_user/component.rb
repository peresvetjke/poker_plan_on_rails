class RoundUser::Component < ViewComponent::Base
  def initialize(round_user:, user_voted:)
    @round_user = round_user
    @user_voted = user_voted
    super
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/round_user/component',
      locals: { round_user:, user:, user_voted: }
    )
  end

  private

  attr_reader :round_user, :user, :user_voted
end
