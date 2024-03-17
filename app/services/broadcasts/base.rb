# frozen_string_literal: true

module Broadcasts
  class Base
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    private

    def render(component)
      ViewComponentController.render(component)
    end
  end
end
