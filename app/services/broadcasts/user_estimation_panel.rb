# frozen_string_literal: true

module Broadcasts
  class UserEstimationPanel < Base
    TARGET = 'estimation_panel'
    VIEW_COMPONENT_KLASS = EstimationPanel::Component

    def hide(round_id:, user_id:)
      broadcast_update_later_to round_per_user_dom_id(round_id, user_id),
                                target: TARGET,
                                html: ''
    end

    def update(round_id:, user_id:, task_id:, value:)
      broadcast_update_later_to round_per_user_dom_id(round_id, user_id),
                                target: TARGET,
                                html: render(VIEW_COMPONENT_KLASS.new(task_id:, value: value))
    end

    private

    def round_per_user_dom_id(round_id, user_id)
      "round_#{round_id}_user_#{user_id}"
    end
  end
end
