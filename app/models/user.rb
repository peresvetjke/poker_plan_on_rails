# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :estimations, dependent: :destroy
  has_many :round_users, dependent: :destroy
  has_many :rounds, through: :round_users

  validates :email, presence: true
  validates :email, uniqueness: true, if: -> { email.present? }

  def username
    super.presence || email.split('@').first
  end
end
