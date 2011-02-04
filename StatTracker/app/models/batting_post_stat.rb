class BattingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :games, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :runs_batted_in, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays
	
	belongs_to :player
	belongs_to :team
	
end
