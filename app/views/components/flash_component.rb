# frozen_string_literal: true

class FlashComponent < ApplicationComponent
  def initialize(message:)
    @message = message
    super
  end
end
