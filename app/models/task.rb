# frozen_string_literal: true

class Task < ApplicationRecord
  STATE_ORDER = %w[ongoing idle finished].freeze

  enum :state, %i[idle ongoing finished]

  belongs_to :round
  has_many :estimations, dependent: :destroy

  validates :title, presence: true

  scope :by_state, -> { in_order_of(:state, STATE_ORDER) }

  default_scope { by_state }

  def start!
    return unless idle?

    ActiveRecord::Base.transaction do
      Task.ongoing.where(round_id: round_id).update(state: :idle)
      ongoing!
    end
  end

  def stop!
    return unless ongoing?

    idle!
  end

  def estimate(user, value)
    return unless ongoing?

    estimation = estimations.find_or_initialize_by(user_id: user.id)
    return estimation.destroy! if estimation.value == value

    ActiveRecord::Base.transaction do
      estimation.update(value: value)
      finished! if evaluated?
    end
  end

  def evaluated?
    User.with_estimation_of_task(id) == round.users
  end
end
