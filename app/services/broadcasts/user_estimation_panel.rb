# frozen_string_literal: true

module Broadcasts
  class UserEstimationPanel < Base
    def hide(round_id:, user_id:)
      broadcast_update_later_to round_user_channel(round_id, user_id),
                                target: estimation_panel_frame_tag,
                                html: ''
    end

    def update(round_id:, user_id:, task_id:, value:)
      broadcast_update_later_to round_user_channel(round_id, user_id),
                                target: estimation_panel_frame_tag,
                                html: render(::EstimationPanel::Component.new(task_id:, value:))
    end

    private

    attr_reader :component_klass
  end
end
