class SearchBox::Component
  def render_in(view_context)
    view_context.render(
      partial: "components/search_box/component",
      locals: {c: self}
    )
  end
end
