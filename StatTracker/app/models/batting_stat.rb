class BattingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort()
		sorted = BattingStat.all.sort{|a,b| b.rbi <=> a.rbi}
		return sorted.take(50)
	end
	
	def self.career_sort()
		stats = {}
		BattingStat.all.each { |s|
			if stats.has_key?(s.player_id)
				stats[s.player_id] += s.home_runs
			else stats.store(s.player_id, s.home_runs)
			end
		}
		sorted = stats.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
		a[0] = Player.find(a[0])
		}
		return sorted
	end
	
	def self.active_sort()
		stats = {}
		BattingStat.all.each { |s|
			player = Player.find(s.player_id)

			if player.final_game == nil
				if stats.has_key?(player)
					stats[player] += s.home_runs
				else stats.store(player, s.home_runs)
				end
			end
		}
		sorted = stats.sort{|a,b| b[1] <=> a[1]}
		# sorted.take(50).each { |a| 
		# a[0] = Player.find(a[0])
		# }
		return sorted.take(50)
	end
	
end
