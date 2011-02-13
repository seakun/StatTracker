class PitchingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :wins, :losses, :games, :games_started, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits, :earned_runs, :home_runs, :walks, :strikeouts, :intentional_walks, :wild_pitches, :hit_by_pitch, :balks, :batters_faced, :games_finished, :runs, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort()
		sorted = PitchingPostStat.all.sort{|a,b| b.strikeouts <=> a.strikeouts}
		return sorted.take(50)
	end
	
	def self.career_sort()
		stats = {}
		PitchingPostStat.all.each { |s|
			if stats.has_key?(s.player_id)
				stats[s.player_id] += s.strikeouts
			else stats.store(s.player_id, s.strikeouts)
			end
		}
		sorted = stats.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
		a[0] = Player.find(a[0])
		}
		return sorted.take(50)
	end
	
end
