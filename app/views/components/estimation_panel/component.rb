class EstimationPanel::Component < ViewComponent::Base
  def initialize(task_id:, value:)
    @task_id = task_id
    @value = value.to_i
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/estimation_panel/component',
      locals: { task_id:, value: }
    )
  end

  private

  attr_reader :task_id, :value
end
