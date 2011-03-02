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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110222030030) do

  create_table "batting_post_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.string   "round"
    t.integer  "games"
    t.integer  "plate_appearances"
    t.integer  "at_bats"
    t.integer  "runs"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "triples"
    t.integer  "home_runs"
    t.integer  "total_bases"
    t.integer  "extra_base_hits"
    t.integer  "rbi"
    t.integer  "stolen_bases"
    t.integer  "caught_stealing"
    t.integer  "walks"
    t.integer  "strikeouts"
    t.integer  "intentional_walks"
    t.integer  "hit_by_pitch"
    t.integer  "sacrifice_hits"
    t.integer  "sacrifice_flies"
    t.integer  "grounded_into_double_plays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batting_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "stint"
    t.integer  "games"
    t.integer  "games_batting"
    t.integer  "plate_appearances"
    t.integer  "at_bats"
    t.integer  "runs"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "triples"
    t.integer  "home_runs"
    t.integer  "total_bases"
    t.integer  "extra_base_hits"
    t.integer  "rbi"
    t.integer  "stolen_bases"
    t.integer  "caught_stealing"
    t.integer  "walks"
    t.integer  "strikeouts"
    t.integer  "intentional_walks"
    t.integer  "hit_by_pitch"
    t.integer  "sacrifice_hits"
    t.integer  "sacrifice_flies"
    t.integer  "grounded_into_double_plays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fielding_post_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.string   "round"
    t.string   "position"
    t.integer  "games"
    t.integer  "games_started"
    t.integer  "inning_outs"
    t.integer  "chances"
    t.integer  "put_outs"
    t.integer  "assists"
    t.integer  "errors_made"
    t.integer  "double_plays"
    t.integer  "triple_plays"
    t.integer  "passed_balls"
    t.integer  "stolen_bases"
    t.integer  "caught_stealing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fielding_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "stint"
    t.string   "position"
    t.integer  "games"
    t.integer  "games_started"
    t.integer  "inning_outs"
    t.integer  "chances"
    t.integer  "put_outs"
    t.integer  "assists"
    t.integer  "errors_made"
    t.integer  "double_plays"
    t.integer  "passed_balls"
    t.integer  "wild_pitches"
    t.integer  "stolen_bases"
    t.integer  "caught_stealing"
    t.integer  "zone_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "franchises", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pitching_post_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.string   "round"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "games"
    t.integer  "games_started"
    t.integer  "complete_games"
    t.integer  "shutouts"
    t.integer  "saves"
    t.integer  "innings_pitched_outs"
    t.integer  "hits"
    t.integer  "earned_runs"
    t.integer  "home_runs"
    t.integer  "walks"
    t.integer  "strikeouts"
    t.integer  "intentional_walks"
    t.integer  "wild_pitches"
    t.integer  "hit_by_pitch"
    t.integer  "balks"
    t.integer  "batters_faced"
    t.integer  "games_finished"
    t.integer  "runs"
    t.integer  "sacrifice_hits"
    t.integer  "sacrifice_flies"
    t.integer  "grounded_into_double_plays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pitching_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "stint"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "games"
    t.integer  "games_started"
    t.integer  "complete_games"
    t.integer  "shutouts"
    t.integer  "saves"
    t.integer  "innings_pitched_outs"
    t.integer  "hits"
    t.integer  "earned_runs"
    t.integer  "home_runs"
    t.integer  "walks"
    t.integer  "strikeouts"
    t.integer  "intentional_walks"
    t.integer  "wild_pitches"
    t.integer  "hit_by_pitch"
    t.integer  "balks"
    t.integer  "batters_faced"
    t.integer  "games_finished"
    t.integer  "runs"
    t.integer  "sacrifice_hits"
    t.integer  "sacrifice_flies"
    t.integer  "grounded_into_double_plays"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.integer  "birth_year"
    t.integer  "birth_month"
    t.integer  "birth_day"
    t.string   "birth_country"
    t.string   "birth_state"
    t.string   "birth_city"
    t.integer  "death_year"
    t.integer  "death_month"
    t.integer  "death_day"
    t.string   "death_country"
    t.string   "death_state"
    t.string   "death_city"
    t.integer  "weight"
    t.integer  "height"
    t.string   "bats"
    t.string   "throws"
    t.datetime "debut"
    t.datetime "final_game"
    t.string   "college"
    t.boolean  "hof"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer  "franchise_id"
    t.integer  "division_id"
    t.integer  "year"
    t.string   "baseball_era"
    t.string   "name"
    t.string   "park"
    t.integer  "attendance"
    t.integer  "rank"
    t.integer  "games"
    t.integer  "home_games"
    t.integer  "wins"
    t.integer  "losses"
    t.boolean  "div_win"
    t.boolean  "wc_win"
    t.boolean  "lg_win"
    t.boolean  "ws_win"
    t.integer  "runs"
    t.integer  "plate_appearances"
    t.integer  "at_bats"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "triples"
    t.integer  "home_runs"
    t.integer  "total_bases"
    t.integer  "extra_base_hits"
    t.integer  "walks"
    t.integer  "strikeouts"
    t.integer  "stolen_bases"
    t.integer  "caught_stealing"
    t.integer  "hit_by_pitch"
    t.integer  "sacrifice_flies"
    t.integer  "runs_allowed"
    t.integer  "earned_runs"
    t.integer  "complete_games"
    t.integer  "shutouts"
    t.integer  "saves"
    t.integer  "innings_pitched_outs"
    t.integer  "hits_allowed"
    t.integer  "home_runs_allowed"
    t.integer  "walks_allowed"
    t.integer  "strikeouts_allowed"
    t.integer  "errors_made"
    t.integer  "double_plays"
    t.float    "fielding_percentage"
    t.integer  "batters_park_factor"
    t.integer  "pitchers_park_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
