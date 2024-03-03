module Tasks
  class Start
    def initialize(task)
      @task = task
    end

    def call
      return if task.finished?
      return task.idle! if task.ongoing?

      ActiveRecord::Base.transaction do
        Task.ongoing.where(round_id: task.round_id).each(&:idle!)
        task.ongoing!
      end
    end

    private

    attr_reader :task
  end
end
