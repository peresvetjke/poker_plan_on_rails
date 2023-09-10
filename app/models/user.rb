# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :estimations, dependent: :destroy
  has_many :round_users, dependent: :destroy
  has_many :rounds, through: :round_users

  scope :with_estimation_of_task, ->(task_id) { User.joins(estimations: :task).where(estimations: { task: task_id }) }

  def join(round_id)
    round_user = round_users.find_by(round_id: round_id)
    return if round_user.present?

    round_users.create!(round_id: round_id)
  end

  def leave(round_id)
    round_users.find_by(round_id: round_id)&.destroy
  end
end
