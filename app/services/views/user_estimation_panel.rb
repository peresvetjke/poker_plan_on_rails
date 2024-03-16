# frozen_string_literal: true

module Views
  class UserEstimationPanel < Base
    def initialize(task_id:, round_id:, user_id:)
      @round_id = round_id
      @task_id = task_id
      @user_id = user_id
    end

    def hide
      broadcast_update(html: '')
    end

    def show
      broadcast_update(
        component: component_klass.new(task_id:, value: nil)
      )
    end

    def add_vote(value)
      broadcast_update(
        component: component_klass.new(task_id:, value:)
      )
    end

    private

    attr_reader :round_id, :task_id, :user_id

    def streammable
      "round_#{round_id}_user_#{user_id}"
    end

    def target
      'estimation_panel'
    end

    def component_klass
      EstimationPanel::Component
    end
  end
end
