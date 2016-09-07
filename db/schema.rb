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

ActiveRecord::Schema.define(version: 20160906235610) do

  create_table "card_groups", force: :cascade do |t|
    t.integer "game_id"
    t.integer "card_id"
    t.integer "cooldown_remaining"
    t.boolean "current_hand_card"
    t.boolean "deck_card"
    t.boolean "cooldown_card"
    t.boolean "inplay_card"
  end

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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.integer  "opponent_id"
  end

  create_table "skill_cards", force: :cascade do |t|
    t.string   "name"
    t.integer  "class_id"
    t.string   "card_type"
    t.integer  "cost"
    t.string   "attack_type"
    t.integer  "attack_targets"
    t.integer  "damage"
    t.string   "description"
    t.string   "bonus_method"
    t.integer  "buff_id"
    t.integer  "debuff_id"
    t.integer  "cooldown"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "image_path"
  end

  add_index "skill_cards", ["class_id"], name: "index_skill_cards_on_class_id"
  add_index "skill_cards", ["name"], name: "index_skill_cards_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end