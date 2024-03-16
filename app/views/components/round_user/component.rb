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


# class UsersList::Component < ViewComponent::Base
#   def self.target(round)
#     "round_#{round.id}_users_list"
#   end

#   def initialize(
#     round:,
#     round_users: round.round_users.preload(:user),
#     voted_user_ids: Set.new(Estimation.where(task_id: round.current_task&.id)&.pluck(:user_id).to_a)
#     )
#     @round = round
#     @round_users = round_users
#     @voted_user_ids = voted_user_ids
#   end

#   def render_in(view_context)
#     view_context.render(
#       partial: 'components/users_list/component',
#       locals: { round_users:, voted_user_ids: }
#     )
#   end

#   private

#   attr_reader :round_users, :voted_user_ids
# end
