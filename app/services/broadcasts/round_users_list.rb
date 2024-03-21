# frozen_string_literal: true

module Broadcasts
  class RoundUsersList < Base
    VIEW_COMPONENT_KLASS = RoundUserComponent

    def user_joined(round_user:, user_voted:)
      broadcast_prepend_later_to channel(round_user),
                                 target: 'users_list',
                                 html: render(VIEW_COMPONENT_KLASS.new(round_user:, user_voted:))
    end

    def user_left(round_user:)
      broadcast_remove_to channel(round_user),
                          target: "round_user_#{round_user.id}"
    end

    def estimation_added(round_user:)
      broadcast_update_later_to channel(round_user),
                                target: "round_user_#{round_user.id}",
                                html: render(VIEW_COMPONENT_KLASS.new(round_user:, user_voted: true))
    end

    def estimation_removed(round_user:)
      broadcast_update_later_to channel(round_user),
                                target: "round_user_#{round_user.id}",
                                html: render(VIEW_COMPONENT_KLASS.new(round_user:, user_voted: false))
    end

    private

    def channel(round_user)
      "round_#{round_user.round_id}"
    end

    attr_reader :round_user
  end
end
