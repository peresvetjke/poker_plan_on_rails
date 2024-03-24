# frozen_string_literal: true

module Broadcasts
  class Base
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    def initialize(**options); end

    private

    def render(component)
      controller.render(component)
    end

    def controller
      ViewComponentController
    end
  end
end
