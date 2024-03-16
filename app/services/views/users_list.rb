# frozen_string_literal: true

module Views
  class UsersList < Base
    def initialize(round_user)
      @round_user = round_user
    end

    def estimation_added
      broadcast_update(
        component: component_klass.new(round_user:, user_voted: true)
      )
    end

    def estimation_removed
      broadcast_update(
        component: component_klass.new(round_user:, user_voted: false)
      )
    end

    private

    attr_reader :round_user

    def streammable
      "round_#{round_user.round_id}"
    end

    def target
      "round_user_#{round_user.id}"
    end

    def component_klass
      ::RoundUser::Component
    end
  end
end
