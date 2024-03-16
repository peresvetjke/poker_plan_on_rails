# frozen_string_literal: true

module Tasks
  class FinishChecker
    # @param task [task]
    # @return [Boolean]
    def call(task)
      task.estimations.pluck(:user_id).sort == task.round.round_users.pluck(:user_id).sort
    end
  end
end
