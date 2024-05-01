# frozen_string_literal: true

class EstimationPanelComponent < ApplicationComponent
  def initialize(current_task: nil, current_value: nil)
    @current_task = current_task
    @current_value = current_value
    super
  end

  # def render?
  #   @current_task.present?
  # end
end
