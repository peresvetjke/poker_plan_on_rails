class BaseViewComponent < ViewComponent::Base
  class << self
    def render(component)
      ViewComponentController.render(component)
    end
  end
end
