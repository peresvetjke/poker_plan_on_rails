module Tasks
  class Start
    def initialize(task:)
      @task = task
      @round = Round.find(task.round_id)
    end

    def call
      return if task.finished?
      return stop_task if task.ongoing?

      start_task
    end

    private

    attr_reader :task, :round

    def stop_task
      return unless ActiveRecord::Base.transaction do
        task.estimations.destroy_all
        task.idle!
      end

      hide_estimation_panels
    end

    def start_task
      return unless ActiveRecord::Base.transaction do
        Task.ongoing.where(round_id: task.round_id).each(&:idle!)
        task.ongoing!
      end

      initiate_estimation_panels
    end

    def initiate_estimation_panels
      round.users.each do |user|
        estimation_panel.update(round_id: round.id, task_id: task.id, user_id: user.id, value: nil)
      end
    end

    def hide_estimation_panels
      round.users.each do |user|
        estimation_panel.hide(round_id: round.id, user_id: user.id)
      end
    end

    def estimation_panel
      @estimation_panel ||= Broadcasts::UserEstimationPanel.new
    end
  end
end
