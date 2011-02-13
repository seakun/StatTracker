class PitchingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :wins, :losses, :games, :games_started, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits, :earned_runs, :home_runs, :walks, :strikeouts, :intentional_walks, :wild_pitches, :hit_by_pitch, :balks, :batters_faced, :games_finished, :runs, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort()
		sorted = PitchingStat.all.sort{|a,b| b.strikeouts <=> a.strikeouts}
		return sorted.take(50)
	end
	
end
