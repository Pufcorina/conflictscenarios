# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_26_074337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brochure_answers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "brochure_id"
    t.bigint "question_id"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brochure_members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "brochure_id"
    t.boolean "answered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brochures", force: :cascade do |t|
    t.string "title"
    t.string "subdescription"
    t.string "description"
    t.date "sent_at"
    t.integer "brochures_nb"
    t.string "author"
  end

  create_table "detail_fields", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "row"
    t.integer "column"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "detail_forms", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_questions", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "question_id"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id"
    t.string "title"
    t.integer "order"
    t.string "aux_description"
  end

  create_table "policies", force: :cascade do |t|
    t.string "name"
    t.string "content"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.bigint "survey_id"
    t.string "question_type"
    t.integer "order"
    t.boolean "required"
    t.text "description"
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relation_brochure_scenario_members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "survey_id"
    t.bigint "brochure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relation_brochure_scenarios", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "brochure_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "send_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.boolean "manager"
    t.boolean "employee"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.date "date_of_birth"
    t.string "city"
    t.string "country"
    t.string "gender"
    t.string "avatar"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
