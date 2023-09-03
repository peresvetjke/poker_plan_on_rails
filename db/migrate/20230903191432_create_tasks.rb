# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.references :round, null: false, foreign_key: true
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
