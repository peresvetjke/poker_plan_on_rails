module Tasks
  class Estimate
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    def initialize(task:, user:)
      @task = task
      @user = user
    end

    def call(value)
      return unless task.ongoing?

      estimation = task.estimations.find_or_initialize_by(user_id: user.id)
      if estimation.value == value
        estimation.destroy!
        broadcast(user)
      else
        ActiveRecord::Base.transaction do
          estimation.update!(value:)
          task.finished! if task_estimated?(task)
        end
        (task.round.users - [user]).each { |u| broadcast(u) }
      end
    end

    private

    def task_estimated?(task)
      task.estimations.pluck(:user_id).sort == task.round.round_users.pluck(:user_id).sort
    end

    def broadcast(user_to)
      broadcast_update_to "round_#{task.round_id}_user_#{user_to.id}_estimation_panel",
        target: "round_#{task.round_id}_user_#{user_to.id}_estimation_panel",
        partial: "rounds/estimation_panel",
        locals: { round: task.round, user: user_to }
      # broadcast_update_to "round_#{task.round_id}_user_#{user_to.id}_estimation_panel", ""
      # broadcast_replace_to "round_#{task.round_id}_user_#{user_to.id}_estimation_panel", "Tratata"
    end

    attr_reader :task, :user
  end
end
