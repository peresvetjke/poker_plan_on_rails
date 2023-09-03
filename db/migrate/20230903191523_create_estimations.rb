# frozen_string_literal: true

class CreateEstimations < ActiveRecord::Migration[7.0]
  def change
    create_table :estimations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
