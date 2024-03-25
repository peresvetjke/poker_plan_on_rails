module Listeners
  class Round < Base
    EVENTS = %i[task_started task_stopped task_finished
                user_joined user_left
                estimation_added estimation_removed].freeze

    delegate *EVENTS, to: :delivery

    attr_reader :delivery

    def initialize(delivery: Delivery::WebBroadcast.new)
      @delivery = delivery
      super
    end
  end
end
