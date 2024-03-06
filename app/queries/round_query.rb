class RoundQuery
  attr_reader :round

  delegate :current_task, to: :round

  # @param round_id [Integer]
  def initialize(round_id)
    @round = Round.where(id: round_id).preload(:users, :current_task, current_task: estimations).first
  end

  # @return Set<User>
  def users
    @users ||= Set.new(round.users)
  end

  # @return Set<RoundUser>
  def round_users
    @round_users ||= Set.new(round.round_users)
  end

  # @return Set<Integer>
  def voted_user_ids
    @voted_user_ids ||= Set.new(Estimation.where(task_id: current_task&.id)&.pluck(:user_id))
  end
end
