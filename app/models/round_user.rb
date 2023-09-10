# frozen_string_literal: true

class RoundUser < ApplicationRecord
  belongs_to :round
  belongs_to :user
end
