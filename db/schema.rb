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

ActiveRecord::Schema[7.0].define(version: 2022_11_17_053812) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.string "match_id"
    t.integer "region"
    t.datetime "started_at"
    t.integer "duration"
    t.integer "game_mode"
    t.integer "game_type"
    t.string "game_version"
    t.integer "map_id"
    t.integer "queue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_matches_on_match_id", unique: true
  end

  create_table "summoners", force: :cascade do |t|
    t.string "name"
    t.integer "region"
    t.string "encrypted_id"
    t.string "puuid"
    t.integer "profile_icon_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "region"], name: "index_summoners_on_name_and_region", unique: true
    t.index ["puuid"], name: "index_summoners_on_puuid", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "match_id"
    t.integer "team_id"
    t.boolean "win"
    t.boolean "first_baron"
    t.integer "baron_kills"
    t.boolean "first_champion"
    t.integer "champion_kills"
    t.boolean "first_dragon"
    t.integer "dragon_kills"
    t.boolean "first_inhibitor"
    t.integer "inhibitor_kills"
    t.boolean "first_rift_herald"
    t.integer "rift_herald_kills"
    t.boolean "first_tower"
    t.integer "tower_kills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_teams_on_match_id"
  end

  add_foreign_key "teams", "matches"
end
