# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_10_091814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "estimations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_estimations_on_task_id"
    t.index ["user_id", "task_id"], name: "index_estimations_on_user_id_and_task_id", unique: true
    t.index ["user_id"], name: "index_estimations_on_user_id"
  end

  create_table "round_users", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id", "user_id"], name: "index_round_users_on_round_id_and_user_id", unique: true
    t.index ["round_id"], name: "index_round_users_on_round_id"
    t.index ["user_id"], name: "index_round_users_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_rounds_on_title", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "round_id", null: false
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_tasks_on_round_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_moderator", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "estimations", "tasks"
  add_foreign_key "estimations", "users"
  add_foreign_key "round_users", "rounds"
  add_foreign_key "round_users", "users"
  add_foreign_key "tasks", "rounds"
end
