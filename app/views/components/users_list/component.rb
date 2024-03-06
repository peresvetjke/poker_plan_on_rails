class UsersList::Component < ViewComponent::Base
  def self.target(round)
    "round_#{round.id}_users_list"
  end

  def initialize(users:, round_users:, voted_user_ids:)
    @users = users
    @round_users = round_users
    @voted_user_ids = voted_user_ids
    super
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/users_list/component',
      locals: { users:, round_users:, voted_user_ids: }
    )
  end

  private

  attr_reader :users, :round_users, :voted_user_ids
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