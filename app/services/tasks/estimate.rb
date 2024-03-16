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
      @round_user = RoundUser.where(round_id: task.round_id, user_id: user.id).preload(:user).first
    end

    # @param value [Integer]
    # @return [void]
    def call(value)
      return unless task.ongoing?

      estimation = task.estimations.find_or_initialize_by(user_id: user.id)
      result = if estimation.value == value
        estimation.destroy!
        user_voted = false
        nil
      else
        ActiveRecord::Base.transaction do
          estimation.update!(value:)
          task.finished! if FinishChecker.new.call(task)
        end
        user_voted = true
        estimation
      end
      broadcast_update(user_voted)
      result
    end

    private

    def destroy_estimation

    end

    def broadcast_update(user_voted)
      broadcast_update_later_to "round_#{round_user.round_id}",
        target: "round_user_#{round_user.id}",
        html: ViewComponentController.render(
          RoundUser::Component.new(round_user:, user_voted:)
        )
    end

    attr_reader :task, :user, :round_user
  end
end
