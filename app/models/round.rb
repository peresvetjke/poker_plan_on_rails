# frozen_string_literal: true

class Round < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :round_users, dependent: :destroy
  has_many :users, through: :round_users
end
