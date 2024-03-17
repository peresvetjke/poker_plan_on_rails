class EstimationPanel::Component < BaseViewComponent
  def self.frame_tag
    'estimation_panel'
  end

  def initialize(task_id:, value:, frame_tag: self.class.frame_tag)
    @task_id = task_id
    @value = value.to_i
    @frame_tag = frame_tag
  end

  def render_in(view_context)
    view_context.render(
      partial: 'components/estimation_panel/component',
      locals: { task_id:, value:, frame_tag: }
    )
  end

  private

  attr_reader :task_id, :value, :frame_tag
end
