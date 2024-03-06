module Tasks
  class Start
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    def initialize(task:)
      @task = task
      @round = Round.find(task.round_id)
    end

    def call
      return if task.finished?

      if task.ongoing?
        task.idle!

        round.users.each do |u|
          broadcast_update_later_to "round_#{round.id}_user_#{u.id}",
            target: 'estimation_panel',
            html: ''
        end
      else
        ActiveRecord::Base.transaction do
          Task.ongoing.where(round_id: task.round_id).each(&:idle!)
          task.ongoing!
        end

        round.users.each do |u|
          broadcast_update_later_to "round_#{round.id}_user_#{u.id}",
            target: 'estimation_panel',
            html: ViewComponentController.render(
                    EstimationPanel::Component.new(task: task, value: Estimation.find_by(task_id: task.id, user_id: u.id)&.value)
                  )
        end
      end
    end

    private

    attr_reader :task, :round
  end
end
