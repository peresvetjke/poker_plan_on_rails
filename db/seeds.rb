# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

%w[Frontend Backend].each do |t|
  round = Round.create!(title: t)
  (1..3).each { |n| round.tasks.create!(title: "Task ##{n}") }
end
