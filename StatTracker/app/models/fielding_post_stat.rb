class FieldingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :position, :games, :games_started, :inning_outs, :chances, :put_outs, :assists, :errors_made, :double_plays, :triple_plays, :passed_balls, :stolen_bases, :caught_stealing
	
	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		sorted = FieldingPostStat.all.sort{|a,b| b.send(stat) <=> a.send(stat)}
		return sorted.take(50)
	end
	
	def self.career_sort(stat)
		stats = {}
		FieldingPostStat.all.each { |s|
			if stats.has_key?(s.player_id)
				stats[s.player_id] += s.send(stat)
			else stats.store(s.player_id, s.send(stat))
			end
		}
		sorted = stats.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
		a[0] = Player.find(a[0])
		}
		return sorted.take(50)
	end
	
	def self.active_sort(stat)
		stats = {}
		FieldingPostStat.all.each { |s|
			player = Player.find(s.player_id)
			if player.final_game.nil?
				if stats.has_key?(player)
					stats[player] += s.send(stat)
				else stats.store(player, s.send(stat))
				end
			end
		}
		sorted = stats.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
			a[0] = Player.find(a[0])
		}
		return sorted.take(50)
	end
	
end
