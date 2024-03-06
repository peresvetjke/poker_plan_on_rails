class EstimationPanel::Component < ViewComponent::Base
  def initialize(task:, value:)
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
