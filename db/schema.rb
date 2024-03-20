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

ActiveRecord::Schema[7.1].define(version: 2024_03_20_171553) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "editors", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "event_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.boolean "active"
    t.bigint "event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "start_date"
    t.date "end_date"
    t.time "start_time"
    t.time "end_time"
    t.boolean "all_day"
    t.string "location"
    t.bigint "organizer_id"
    t.bigint "score_type_id"
    t.integer "status"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investor_matrices", force: :cascade do |t|
    t.float "total_amount"
    t.float "one_time_pay"
    t.integer "event_id"
    t.float "judge_acc_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "investor_type", default: 1
  end

  create_table "judges", force: :cascade do |t|
    t.integer "member_id"
    t.integer "event_id"
    t.integer "current_amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.integer "judge_type", default: 1
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.string "address"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "org_name"
    t.string "profile_url"
    t.integer "faculty_id"
    t.string "phone"
  end

  create_table "score_infos", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_matrices", force: :cascade do |t|
    t.float "weight"
    t.float "max"
    t.float "min"
    t.bigint "event_id"
    t.bigint "score_info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_types", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_events", force: :cascade do |t|
    t.integer "team_id"
    t.integer "event_id"
    t.float "total_score", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_members", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "team_id"
    t.boolean "leader"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.boolean "active"
    t.string "website_link"
    t.bigint "organizer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.float "total_score"
    t.integer "pitching_order", default: 1
  end

  create_table "tran_investors", force: :cascade do |t|
    t.float "amount"
    t.string "desc"
    t.bigint "team_event_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "judge_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id"
    t.string "password_digest"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["member_id"], name: "index_users_on_member_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "editors", "events"
  add_foreign_key "editors", "members"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "members", column: "organizer_id"
  add_foreign_key "events", "score_types"
  add_foreign_key "events", "score_types", column: "id"
  add_foreign_key "investor_matrices", "events"
  add_foreign_key "judges", "events"
  add_foreign_key "judges", "members"
  add_foreign_key "members", "faculties"
  add_foreign_key "score_matrices", "events"
  add_foreign_key "score_matrices", "score_infos"
  add_foreign_key "team_events", "events"
  add_foreign_key "team_events", "teams"
  add_foreign_key "team_members", "events"
  add_foreign_key "team_members", "members"
  add_foreign_key "team_members", "teams"
  add_foreign_key "teams", "events"
  add_foreign_key "teams", "members", column: "organizer_id"
  add_foreign_key "tran_investors", "events"
  add_foreign_key "tran_investors", "judges"
  add_foreign_key "tran_investors", "team_events"
  add_foreign_key "users", "members"
end
