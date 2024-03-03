# frozen_string_literal: true

class Task < ApplicationRecord
  enum :state, %i[idle ongoing finished]

  belongs_to :round
  has_many :estimations, dependent: :destroy

  validates :title, presence: true

  broadcasts_to ->(task) { [task.round, :tasks] }, inserts_by: :prepend,
                                                   target: ->(task) { "round_#{task.round_id}_tasks" }

  def estimate(user, value)
    return unless ongoing?

    estimation = estimations.find_or_initialize_by(user_id: user.id)
    return estimation.destroy! if estimation.value == value

    ActiveRecord::Base.transaction do
      estimation.update(value:)
      finished! if evaluated?
    end
  end

  def evaluated?
    User.with_estimation_of_task(id) == round.users
  end
end
