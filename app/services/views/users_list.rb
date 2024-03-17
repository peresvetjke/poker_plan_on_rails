# frozen_string_literal: true

module Views
  class UsersList < Base
    def initialize(round_user:, user:)
      @round_user = round_user
      @user = user
    end

    def user_joined(user_voted)
      component = component_klass.new(round_user:, user:, user_voted:)

      broadcast_prepend_later_to streammable, target: "users_list", html: render(component)
    end

    def user_left
      broadcast_remove_to "round_#{round_user.round_id}", target: "round_user_#{round_user.id}"
    end

    def estimation_added
      component = component_klass.new(round_user:, user:, user_voted: true)

      broadcast_update_later_to streammable, target:, html: render(component)
    end

    def estimation_removed
      component = component_klass.new(round_user:, user: round_user.user, user_voted: false)

      broadcast_update_later_to streammable, target:, html: render(component)
    end

    private

    attr_reader :round_user, :user

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
