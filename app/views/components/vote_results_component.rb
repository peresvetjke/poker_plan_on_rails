# frozen_string_literal: true

class VoteResultsComponent < ApplicationComponent
  def initialize(task:)
    @task = task
    super
  end
end
