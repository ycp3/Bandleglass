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

ActiveRecord::Schema[7.0].define(version: 2023_04_11_011511) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champions", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "internal_name"
    t.text "lore"
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "cost"
    t.integer "sell_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_type", default: 0
  end

  create_table "matches", force: :cascade do |t|
    t.string "match_id"
    t.integer "region"
    t.datetime "started_at"
    t.integer "duration"
    t.string "game_version"
    t.integer "map"
    t.integer "queue_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ended_by"
    t.index ["match_id"], name: "index_matches_on_match_id", unique: true
  end

  create_table "participant_items", force: :cascade do |t|
    t.bigint "participant_id"
    t.bigint "item_id"
    t.integer "slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_participant_items_on_item_id"
    t.index ["participant_id"], name: "index_participant_items_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "summoner_id"
    t.bigint "match_id"
    t.bigint "team_id"
    t.bigint "champion_id"
    t.bigint "summoner_spell_1_id"
    t.bigint "summoner_spell_2_id"
    t.string "name"
    t.integer "level"
    t.integer "profile_icon_id"
    t.integer "cached_tier"
    t.integer "cached_division"
    t.integer "cached_lp"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "champion_level"
    t.integer "champion_transform"
    t.integer "position"
    t.integer "gold_earned"
    t.integer "largest_multikill"
    t.integer "damage_dealt"
    t.integer "damage_taken"
    t.integer "cs"
    t.integer "vision_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["champion_id"], name: "index_participants_on_champion_id"
    t.index ["match_id"], name: "index_participants_on_match_id"
    t.index ["summoner_id"], name: "index_participants_on_summoner_id"
    t.index ["summoner_spell_1_id"], name: "index_participants_on_summoner_spell_1_id"
    t.index ["summoner_spell_2_id"], name: "index_participants_on_summoner_spell_2_id"
    t.index ["team_id"], name: "index_participants_on_team_id"
  end

  create_table "performances", force: :cascade do |t|
    t.bigint "participant_id"
    t.integer "baron_kills"
    t.integer "dragon_kills"
    t.integer "xp"
    t.integer "objective_damage"
    t.integer "turret_damage"
    t.integer "objectives_stolen"
    t.integer "largest_killing_spree"
    t.integer "largest_critical_strike"
    t.integer "physical_damage_dealt"
    t.integer "physical_damage_taken"
    t.integer "magic_damage_dealt"
    t.integer "magic_damage_taken"
    t.integer "true_damage_dealt"
    t.integer "true_damage_taken"
    t.integer "self_mitigated_damage"
    t.integer "cc_score"
    t.integer "control_wards_placed"
    t.integer "stealth_wards_placed"
    t.integer "wards_killed"
    t.boolean "first_blood_assist"
    t.boolean "first_blood_kill"
    t.boolean "first_tower_assist"
    t.boolean "first_tower_kill"
    t.integer "inhibitor_kills"
    t.integer "inhibitor_takedowns"
    t.integer "turret_kills"
    t.integer "turret_takedowns"
    t.integer "gold_spent"
    t.integer "q_casts"
    t.integer "w_casts"
    t.integer "e_casts"
    t.integer "r_casts"
    t.integer "summoner_spell_1_casts"
    t.integer "summoner_spell_2_casts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_performances_on_participant_id"
  end

  create_table "ranks", force: :cascade do |t|
    t.bigint "summoner_id"
    t.integer "queue_type"
    t.integer "tier"
    t.integer "division"
    t.integer "lp"
    t.integer "wins"
    t.integer "losses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["summoner_id"], name: "index_ranks_on_summoner_id"
  end

  create_table "rune_pages", force: :cascade do |t|
    t.bigint "participant_id"
    t.bigint "primary_tree_id"
    t.bigint "keystone_id"
    t.bigint "secondary_tree_id"
    t.integer "offense_stat"
    t.integer "flex_stat"
    t.integer "defense_stat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "row_1_id"
    t.bigint "row_2_id"
    t.bigint "row_3_id"
    t.bigint "secondary_rune_1_id"
    t.bigint "secondary_rune_2_id"
    t.index ["keystone_id"], name: "index_rune_pages_on_keystone_id"
    t.index ["participant_id"], name: "index_rune_pages_on_participant_id"
    t.index ["primary_tree_id"], name: "index_rune_pages_on_primary_tree_id"
    t.index ["row_1_id"], name: "index_rune_pages_on_row_1_id"
    t.index ["row_2_id"], name: "index_rune_pages_on_row_2_id"
    t.index ["row_3_id"], name: "index_rune_pages_on_row_3_id"
    t.index ["secondary_rune_1_id"], name: "index_rune_pages_on_secondary_rune_1_id"
    t.index ["secondary_rune_2_id"], name: "index_rune_pages_on_secondary_rune_2_id"
    t.index ["secondary_tree_id"], name: "index_rune_pages_on_secondary_tree_id"
  end

  create_table "rune_trees", force: :cascade do |t|
    t.string "name"
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runes", force: :cascade do |t|
    t.string "name"
    t.bigint "rune_tree_id"
    t.integer "row"
    t.integer "row_order"
    t.text "description"
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rune_tree_id"], name: "index_runes_on_rune_tree_id"
  end

  create_table "spells", force: :cascade do |t|
    t.bigint "champion_id"
    t.integer "spell_type"
    t.string "name"
    t.string "internal_name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["champion_id", "spell_type"], name: "index_spells_on_champion_id_and_spell_type", unique: true
    t.index ["champion_id"], name: "index_spells_on_champion_id"
  end

  create_table "summoner_spells", force: :cascade do |t|
    t.string "name"
    t.string "internal_name"
    t.text "description"
    t.integer "cooldown"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "side"
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
    t.boolean "surrendered"
    t.integer "banned_champion_ids", default: [], array: true
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.index ["match_id"], name: "index_teams_on_match_id"
  end

  add_foreign_key "participant_items", "items"
  add_foreign_key "participant_items", "participants"
  add_foreign_key "participants", "champions"
  add_foreign_key "participants", "matches"
  add_foreign_key "participants", "summoner_spells", column: "summoner_spell_1_id"
  add_foreign_key "participants", "summoner_spells", column: "summoner_spell_2_id"
  add_foreign_key "participants", "summoners"
  add_foreign_key "participants", "teams"
  add_foreign_key "performances", "participants"
  add_foreign_key "ranks", "summoners"
  add_foreign_key "rune_pages", "participants"
  add_foreign_key "rune_pages", "rune_trees", column: "primary_tree_id"
  add_foreign_key "rune_pages", "rune_trees", column: "secondary_tree_id"
  add_foreign_key "rune_pages", "runes", column: "keystone_id"
  add_foreign_key "rune_pages", "runes", column: "row_1_id"
  add_foreign_key "rune_pages", "runes", column: "row_2_id"
  add_foreign_key "rune_pages", "runes", column: "row_3_id"
  add_foreign_key "rune_pages", "runes", column: "secondary_rune_1_id"
  add_foreign_key "rune_pages", "runes", column: "secondary_rune_2_id"
  add_foreign_key "runes", "rune_trees"
  add_foreign_key "spells", "champions"
  add_foreign_key "teams", "matches"
end
