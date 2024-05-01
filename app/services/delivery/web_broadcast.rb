# frozen_string_literal: true

module Delivery
  class WebBroadcast
    def task_started(task:)
      fill_estimation_panel(task.round)
      update_users_list(task.round)
    end

    def task_stopped(task:)
      clean_estimation_panel(task.round_id)
      update_users_list(task.round)
    end

    def task_finished(task:)
      round = task.round
      clean_estimation_panel(task.round_id)
      update_users_list(round)
      update_finished_tasks_link(round)
      show_results(task, task.round_id)
    end

    def user_joined(round_user:)
      add_round_user(round_user)
    end

    def user_left(round_user:)
      remove_round_user(round_user)

      current_task = round_user.round.current_task
      FinishTaskJob.perform_later(current_task.id) if current_task.present?
    end

    def estimation_added(round_user:)
      update_round_user(round_user, true)

      current_task = round_user.round.current_task
      FinishTaskJob.perform_later(current_task.id) if current_task.present?
    end

    def estimation_removed(round_user:)
      update_round_user(round_user, false)
    end

    private

    def fill_estimation_panel(round)
      current_task = round.current_task
      round.round_users.each do |round_user|
        current_value = current_task.estimations.find_by(user_id: round_user.user_id)&.value
        user = round_user.user
        Turbo::StreamsChannel.broadcast_update_later_to(
          "round_#{round_user.round_id}_user_#{round_user.user_id}",
          target: 'estimation_panel',
          partial: 'rounds/estimation_panel',
          locals: { current_task:, user:, current_value: }
        )
      end
    end

    def clean_estimation_panel(round_id)
      Turbo::StreamsChannel.broadcast_update_later_to(
        "round_#{round_id}",
        target: 'estimation_panel',
        partial: 'rounds/estimation_panel',
        locals: { current_task: nil, user: nil, current_value: nil }
      )
    end

    def update_users_list(round)
      Turbo::StreamsChannel.broadcast_update_later_to(
        "round_#{round.id}",
        target: 'users_list',
        partial: 'rounds/users_list',
        locals: { round: }
      )
    end

    def update_finished_tasks_link(round)
      Turbo::StreamsChannel.broadcast_update_later_to(
        "round_#{round.id}",
        target: 'finished_tasks_link',
        partial: 'rounds/finished_tasks_link',
        locals: { round: }
      )
    end

    def show_results(task, round_id)
      Turbo::StreamsChannel.broadcast_prepend_later_to(
        "round_#{round_id}",
        target: 'modal',
        partial: 'tasks/vote_results',
        locals: { task: }
      )
    end

    def add_round_user(round_user)
      current_task = round_user.round.current_task
      user_voted = current_task.blank? ? nil : Estimation.exists?(task_id: current_task&.id, user_id: round_user.user_id)
      Turbo::StreamsChannel.broadcast_prepend_later_to(
        "round_#{round_user.round_id}",
        target: 'users_list',
        partial: 'round_users/round_user',
        locals: { round_user:, user: round_user.user, user_voted: }
      )
    end

    def remove_round_user(round_user)
      # https://github.com/hotwired/turbo-rails/issues/506
      Turbo::StreamsChannel.broadcast_remove_to(
        "round_#{round_user.round_id}",
        target: "round_user_#{round_user.id}"
      )
    end

    def update_round_user(round_user, user_voted)
      Turbo::StreamsChannel.broadcast_update_later_to(
        "round_#{round_user.round_id}",
        target: "round_user_#{round_user.id}",
        partial: 'round_users/round_user',
        locals: { round_user:, user: round_user.user, user_voted: }
      )
    end

    def render(component)
      controller.render(component)
    end

    def controller
      ViewComponentController
    end
  end
end
