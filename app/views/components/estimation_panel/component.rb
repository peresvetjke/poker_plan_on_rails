class EstimationPanel::Component
  def initialize(round:,
                 user:,
                 task: round.current_task,
                 value: task.present? ? Estimation.find_by(user_id: user.id, task_id: task.id)&.value : nil)
    @task = task
    @value = value
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/estimation_panel/component',
      locals: { task:, value: }
    )
  end

  private

  attr_reader :task, :value
end
