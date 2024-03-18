# frozen_string_literal: true

module Broadcasts
  class Base
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    def method_missing(m, *args, &block)
      helpers = controller.helpers
      return helpers.public_send(m, *args, &block) if helpers.respond_to?(m)

      super
    end

    private

    def render(component)
      controller.render(component)
    end

    def controller
      ViewComponentController
    end
  end
end
