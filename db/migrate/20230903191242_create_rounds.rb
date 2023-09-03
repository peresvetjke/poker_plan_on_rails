# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.string :title, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
