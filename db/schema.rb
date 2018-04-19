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

ActiveRecord::Schema.define(version: 20180418144504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buckets", force: :cascade do |t|
    t.bigint "cohort_id"
    t.integer "lower_b", null: false
    t.integer "upper_b", null: false
    t.integer "orderers", default: 0, null: false
    t.integer "first_time_orderers", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_buckets_on_cohort_id"
    t.index ["lower_b"], name: "index_buckets_on_lower_b"
    t.index ["upper_b"], name: "index_buckets_on_upper_b"
  end

  create_table "cohorts", force: :cascade do |t|
    t.datetime "start", null: false
    t.datetime "end", null: false
    t.integer "users", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start", "end"], name: "index_cohorts_on_start_and_end", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "order_num", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "order_num"], name: "index_orders_on_user_id_and_order_num"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "signups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "signup_date", null: false
    t.index ["user_id"], name: "index_signups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "buckets", "cohorts"
end
