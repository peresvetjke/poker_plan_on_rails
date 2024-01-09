class Button::Component
  attr_reader :path, :title, :type, :icon

  def initialize(options = {})
    @type = options[:type]
    @title = options[:title]
    @path = options[:path]
    @icon = options[:icon]
  end

  def render_in(view_context)
    view_context.render(
      partial: partial,
      locals: {c: self}
    )
  end

  def partial
    "components/button/#{type}"
  end
end
