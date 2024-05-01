module Delivery
  class WebBroadcast < Base
    include Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName

    def task_started(task:)
      fill_estimation_panel(task.round)
      send_message("Estimation of #{task.title} started. Please vote!", round_id: task.round_id)
    end

    def task_stopped(task:)
      clean_estimation_panel(task.round_id)
    end

    def task_finished(task:)
      clean_estimation_panel(task.round_id)
      show_results(task)
    end

    def user_joined(round_user:)
      add_round_user(round_user)
    end

    def user_left(round_user:)
      remove_round_user(round_user)
    end

    def estimation_added(round_user:)
      update_round_user(round_user, true)
    end

    def estimation_removed(round_user:)
      update_round_user(round_user, false)
    end

    private

    def fill_estimation_panel(round)
      current_task = round.current_task

      round.round_users.each do |round_user|
        current_value = current_task.estimations.find_by(user_id: round_user.user_id)&.value
        broadcast_update_later_to "round_#{round_user.round_id}_user_#{round_user.user_id}",
                            target: 'estimation_panel',
                            html: render(EstimationPanelComponent.new(current_task:, current_value:))
      end
    end

    def clean_estimation_panel(round_id)
      broadcast_update_later_to "round_#{round_id}",
                          target: 'estimation_panel',
                          html: render(EstimationPanelComponent.new(current_task: nil, current_value: nil))
    end

    def send_message(message, round_id:)
      broadcast_prepend_later_to "round_#{round_id}",
                           target: 'flash',
                           html: render(FlashComponent.new(message:))
    end

    def show_results(task)
      broadcast_update_later_to "round_#{task.round.id}",
                          target: "modal",
                          html: render(VoteResultsComponent.new(task:))
    end

    def add_round_user(round_user)
      user_voted = Estimation.exists?(task_id: round_user.round.current_task&.id, user_id: round_user.user_id)
      broadcast_prepend_later_to "round_#{round_user.round_id}",
                            target: 'users_list',
                            html: render(RoundUserComponent.new(round_user:, user_voted:))
    end

    def remove_round_user(round_user)
      broadcast_remove_later_to "round_#{round_user.round_id}",
                          target: "round_user_#{round_user.id}"
    end

    def update_round_user(round_user, user_voted)
      broadcast_update_later_to "round_#{round_user.round_id}",
                          target: "round_user_#{round_user.id}",
                          html: render(RoundUserComponent.new(round_user:, user_voted:))
    end

    def render(component)
      controller.render(component)
    end

    def controller
      ViewComponentController
    end
  end
end
