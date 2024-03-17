# frozen_string_literal: true

module Broadcasts
  class UserEstimationPanel < Base
    VIEW_COMPONENT_KLASS = ::EstimationPanel::Component

    delegate :frame_tag, :round_per_user_dom_id, to: VIEW_COMPONENT_KLASS

    def hide(round_id:, user_id:)
      broadcast_update_later_to round_per_user_dom_id(round_id, user_id),
                                target: frame_tag,
                                html: ''
    end

    def update(round_id:, user_id:, task_id:, value:)
      broadcast_update_later_to round_per_user_dom_id(round_id, user_id),
                                target: frame_tag,
                                html: render(VIEW_COMPONENT_KLASS.new(task_id:, value:))
    end
  end
end
