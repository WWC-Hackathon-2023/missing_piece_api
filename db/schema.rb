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

ActiveRecord::Schema[7.0].define(version: 20_231_022_055_841) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loans", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "borrower_id", null: false
    t.bigint "puzzle_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_id"], name: "index_loans_on_borrower_id"
    t.index ["owner_id"], name: "index_loans_on_owner_id"
    t.index ["puzzle_id"], name: "index_loans_on_puzzle_id"
  end

  create_table "puzzles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.string "title"
    t.string "description"
    t.integer "total_pieces"
    t.string "notes"
    t.string "puzzle_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_puzzles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "password_digest"
    t.string "email"
    t.integer "zip_code"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "loans", "puzzles"
  add_foreign_key "loans", "users", column: "borrower_id"
  add_foreign_key "loans", "users", column: "owner_id"
  add_foreign_key "puzzles", "users"
end
