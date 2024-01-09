class Icon::Component
  attr_reader :type, :height

  def initialize(type:, height: 2)
    @type = type
    @height = height
  end

  def render_in(view_context)
    view_context.render(
      partial: "components/icon/#{type}",
      locals: {c: self}
    )
  end
end
