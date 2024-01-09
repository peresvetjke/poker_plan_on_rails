class Task::Component
  attr_reader :task

  delegate :title, :state, :id, to: :@task

  def initialize(task:)
    @task = task
  end

  def render_in(view_context)
    view_context.render(
      partial: "components/task/component",
      locals: {c: self}
    )
  end

  def button
    case task.state
    when 'idle'
      Button::Component.new(type: :with_icon, icon: Icon::Component.new(type: :start), path: "/tasks/#{task.id}/start")
    when 'ongoing'
      Button::Component.new(type: :with_icon, icon: Icon::Component.new(type: :pause), path: "/tasks/#{task.id}/stop")
    else
      raise NotImplementedError
    end
  end
end
