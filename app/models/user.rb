# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :estimations, dependent: :destroy
  has_many :round_users, dependent: :destroy
  has_many :rounds, through: :round_users

  def username
    super.presence || email
  end
end
