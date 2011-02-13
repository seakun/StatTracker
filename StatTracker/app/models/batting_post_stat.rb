class BattingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :games, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort()
		sorted = BattingPostStat.all.sort{|a,b| b.doubles <=> a.doubles}
		return sorted.take(50)
	end
	
end
