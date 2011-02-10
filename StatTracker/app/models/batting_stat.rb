class BattingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays
end
