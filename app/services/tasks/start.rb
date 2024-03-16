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

      show_estimation_panels
    end

    def show_estimation_panels
      for_each_estimation_panel(&:show)
    end

    def hide_estimation_panels
      for_each_estimation_panel(&:hide)
    end

    def for_each_estimation_panel
      round.users.each do |user|
        estimation_panel = Views::UserEstimationPanel.new(round_id: round.id, task_id: task.id, user_id: user.id)
        yield(estimation_panel)
      end
    end
  end
end
