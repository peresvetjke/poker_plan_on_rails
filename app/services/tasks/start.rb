# frozen_string_literal: true

module Tasks
  class Start
    def initialize(task:, listener: nil)
      @task = task
      @round = Round.find(task.round_id)
      @listener = listener || Listeners::Round.new
    end

    def call
      return if task.finished?
      return stop_task if task.ongoing?

      start_task
    end

    private

    attr_reader :task, :round, :listener

    def stop_task
      return unless ActiveRecord::Base.transaction do
        task.estimations.destroy_all
        task.idle!
      end

      listener.task_stopped(task:)
    end

    def start_task
      return unless ActiveRecord::Base.transaction do
        Task.ongoing.where(round_id: task.round_id).find_each(&:idle!)
        task.ongoing!
      end

      listener.task_started(task:)
    end
  end
end
