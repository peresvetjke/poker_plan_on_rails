module Tasks
  class Start
    include Turbo::Streams::Broadcasts

    def initialize(task:, round:)
      @task = task
      @round = round || Round.find(task.round_id)
    end

    def call
      return if task.finished?
      return task.idle! if task.ongoing?

      ActiveRecord::Base.transaction do
        Task.ongoing.where(round_id: task.round_id).each(&:idle!)
        task.ongoing!
      end
      # round.users.each do |user|
      #   broadcast_replace_to "round_#{round.id}_user_#{user.id}_estimation_panel"
      # end
    end

    private

    attr_reader :task, :round
  end
end
