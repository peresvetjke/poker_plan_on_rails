# frozen_string_literal: true

class EstimationPanelComponent < ViewComponent::Base
  def initialize(current_task:, current_value:)
    @current_task = current_task
    @current_value = current_value
  end

  def render?
    @current_task.present?
  end
end
