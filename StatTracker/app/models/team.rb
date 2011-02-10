class Team < ActiveRecord::Base
    attr_accessible :franchise_id, :division_id, :year, :baseball_era, :name, :park, :attendance, :rank, :games, :home_games, :wins, :losses, :div_win, :wc_win, :lg_win, :ws_win, :runs, :plate_appearances, :at_bats, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :walks, :strikeouts, :stolen_bases, :caught_stealing, :hit_by_pitch, :sacrifice_flies, :runs_allowed, :earned_runs, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits_allowed, :home_runs_allowed, :walks_allowed, :strikeouts_allowed, :errors_made, :double_plays, :fielding_percentage, :batters_park_factor, :pitchers_park_factor
end
