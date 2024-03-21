# frozen_string_literal: true

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
        estimation_panel(round:, user:).update(current_task: task, current_value: nil)
      end
    end

    def hide_estimation_panels
      round.users.each do |user|
        estimation_panel(round:, user:).hide
      end
    end

    def estimation_panel(round:, user:)
      Broadcasts::EstimationPanel.new(round:, user:)
    end
  end
end
