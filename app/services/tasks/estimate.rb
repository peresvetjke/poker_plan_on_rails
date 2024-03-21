# frozen_string_literal: true

module Tasks
  class Estimate
    # @param task [Task]
    # @param user [User]
    def initialize(task:, user:)
      @task = task
      @user = user
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

    attr_reader :task, :user, :round_user

    # @param estimation [Estimation]
    # @return [NilClass]
    def destroy_estimation(estimation)
      estimation.destroy!
      round_users_list.estimation_removed(round_user:)
      nil
    end

    # @param estimation [Estimation]
    # @param value [Integer]
    # @return [Estimation]
    def update_estimation(estimation, value)
      return unless ActiveRecord::Base.transaction do
        estimation.update!(value:)
        task_finished?(task) ? task.finished! : true
      end

      round_users_list.estimation_added(round_user:)
      estimation
    end

    def round_users_list
      @round_users_list ||= Broadcasts::RoundUsersList.new
    end

    # @param task [Task]
    # @return [Boolean]
    def task_finished?(task)
      task.estimations.pluck(:user_id).sort == task.round.round_users.pluck(:user_id).sort
    end
  end
end
