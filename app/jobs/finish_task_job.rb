# frozen_string_literal: true

class FinishTaskJob < ApplicationJob
  def perform(task_id, listener: Listeners::Round.new)
    task = Task.find(task_id)
    return unless task_finished?(task)

    task.finished!
    listener.task_finished(task:)
  end

  private

  def task_finished?(task)
    task.estimations.pluck(:user_id).sort == task.round.round_users.pluck(:user_id).sort
  end
end
