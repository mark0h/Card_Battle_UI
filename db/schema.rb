# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160905160004) do

  create_table "class_cards", force: :cascade do |t|
    t.string   "name"
    t.integer  "health"
    t.string   "base_stat"
    t.integer  "mp"
    t.integer  "rp"
    t.integer  "ms"
    t.integer  "rs"
    t.text     "notes"
    t.string   "ally"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_path"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "whose_turn"
    t.integer  "p1_health"
    t.integer  "p2_health"
    t.integer  "round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
