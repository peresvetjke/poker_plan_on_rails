# frozen_string_literal: true

module Views
  class Base
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    private

    def broadcast_update(component: nil, html: ViewComponentController.render(component))
      broadcast_update_later_to streammable, target:, html:
    end

    def streammable
      raise NotImplementedError
    end

    def target
      raise NotImplementedError
    end

    def render(component)
      ViewComponentController.render(component)
    end
  end
end
