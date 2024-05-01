# frozen_string_literal: true

class FinishTaskJob < ApplicationJob
  def perform(task_id)
    task = Task.where(id: task_id).preload(:estimations, round: :users).first
    return unless task_finished?(task)

    task.finished!
    Listeners::Round.new.task_finished(task:)
  end

  private

  def task_finished?(task)
    active_users_ids = task.round.round_users.reject { |x| x.user.is_moderator? }.pluck(:user_id)
    ready_users_ids = task.estimations.pluck(:user_id)

    task.estimations.present? && (active_users_ids - ready_users_ids).empty?
  end
end
