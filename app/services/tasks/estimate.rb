# frozen_string_literal: true

module Tasks
  class Estimate
    # @param task [Task]
    # @param user [User]
    def initialize(task:, user:, listener: nil)
      @task = task
      @user = user
      @listener = listener || Listeners::Round.new
      @round_user = RoundUser.where(round_id: task.round_id, user_id: user.id).preload(:user).first
    end

    # @param value [Integer]
    # @return [Estimation, NilClass]
    def call(value)
      return if !task.ongoing? || round_user.blank?

      estimation = task.estimations.find_or_initialize_by(user_id: user.id)
      return destroy_estimation(estimation) if estimation.value == value

      update_estimation(estimation, value)
    end

    private

    attr_reader :task, :user, :listener, :round_user

    # @param estimation [Estimation]
    # @return [NilClass]
    def destroy_estimation(estimation)
      estimation.destroy!
      listener.estimation_removed(round_user:)
      nil
    end

    # @param estimation [Estimation]
    # @param value [Integer]
    # @return [Estimation]
    def update_estimation(estimation, value)
      estimation.update!(value:)
      listener.estimation_added(round_user:)
      estimation
    end
  end
end
