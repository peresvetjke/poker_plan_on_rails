# frozen_string_literal: true

module Broadcasts
  class UsersList < Base
    VIEW_COMPONENT_KLASS = ::RoundUser::Component

    def user_joined(round_user:, user_voted:)
      broadcast_prepend_later_to round_dom_id(round_user.round_id),
                                 target: 'users_list',
                                 html: render(VIEW_COMPONENT_KLASS.new(round_user:, user_voted:))
    end

    def user_left(round_user:)
      broadcast_remove_to round_dom_id(round_user.round_id),
                          target: round_user_dom_id(round_user.id)
    end

    def estimation_added(round_user:)
      broadcast_update_later_to round_dom_id(round_user.round_id),
                                target: round_user_dom_id(round_user.round_id),
                                html: render(VIEW_COMPONENT_KLASS.new(round_user:, user_voted: true))
    end

    def estimation_removed(round_user:)
      broadcast_update_later_to round_dom_id(round_user.round_id),
                                target: round_user_dom_id(round_user.round_id),
                                html: render(VIEW_COMPONENT_KLASS.new(round_user:, user_voted: false))
    end

    private

    attr_reader :round_user

    def round_dom_id(round_id)
      "round_#{round_id}"
    end

    def round_user_dom_id(round_user_id)
      "round_user_#{round_user_id}"
    end
  end
end
