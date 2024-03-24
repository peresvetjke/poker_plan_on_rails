# frozen_string_literal: true

module Broadcasts
  class EstimationPanel < Base
    def initialize(round:, user:)
      @round = round
      @user = user
      super
    end

    def hide
      broadcast_update_later_to "round_#{round.id}_user_#{user.id}",
                                target: 'estimation_panel',
                                html: ''
    end

    def update(current_task:, current_value:)
      broadcast_update_later_to "round_#{round.id}_user_#{user.id}",
                                target: 'estimation_panel',
                                html: render(EstimationPanelComponent.new(current_task:, current_value:))
    end

    private

    attr_reader :round, :user
  end
end
