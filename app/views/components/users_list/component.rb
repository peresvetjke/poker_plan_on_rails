class UsersList::Component < ViewComponent::Base
  def self.target(round)
    "round_#{round.id}_users_list"
  end

  def initialize(round_users:, voted_user_ids:)
    @round_users = round_users
    @voted_user_ids = voted_user_ids
    super
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/users_list/component',
      locals: { round_users:, voted_user_ids: }
    )
  end

  private

  attr_reader :round_users, :voted_user_ids
end
