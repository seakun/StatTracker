class BattingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	
	def self.single_season_sort()
		stats = {}
		BattingStat.all.each { |s| stats.store(s, s.home_runs) }
		new = stats.sort{|a,b| b[1] <=>a[1]}
		new2 = []
		new.take(50).each { |a| new2.push(a[0]) }
		return new2
	end
	
end
