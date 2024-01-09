class Navbar::Component
  attr_reader :user, :hover_color

  def initialize(user:, options: {})
    @user = user
    options = defaults.merge(options)
    @hover_color = options[:hover_color]
  end

  def render_in(view_context)
    view_context.render(
      partial: "components/navbar/component",
      locals: {c: self}
    )
  end

  private

  def defaults
    {
      hover_color: 'text-blue-200'
    }
  end
end
