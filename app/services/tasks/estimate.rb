# frozen_string_literal: true

module Tasks
  class Estimate
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    # @param task [Task]
    # @param user [User]
    def initialize(task:, user:)
      @task = task
      @user = user
    end

    # @param value [Integer]
    # @return [void]
    def call(value)
      return unless task.ongoing?

      estimation = task.estimations.find_or_initialize_by(user_id: user.id)
      result = proceed_estimation(estimation, value)
      broadcast_update(task.round)
      result
    end

    private

    # @param estimation [Estimation]
    # @param value [Integer]
    # @return [Estimation]
    def proceed_estimation(estimation, value)
      if estimation.value == value
        estimation.destroy!
        nil
      else
        ActiveRecord::Base.transaction do
          estimation.update!(value:)
          task.finished! if task_estimated?(task)
        end
        estimation
      end
    end

    # @param task [Task]
    # @return [Boolean]
    def task_estimated?(task)
      task.estimations.pluck(:user_id).sort == task.round.round_users.pluck(:user_id).sort
    end

    def broadcast_update(round)
      broadcast_update_later_to "round_#{round.id}",
        target: 'users_list',
        html: ViewComponentController.render(
          UsersList::Component.new(users: round.users, round_users: round.round_users, voted_user_ids: round.current_task.estimations.pluck(:user_id))
        )
    end

    attr_reader :task, :user
  end
end
