# frozen_string_literal: true

class CreateRoundUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :round_users do |t|
      t.references :round, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
