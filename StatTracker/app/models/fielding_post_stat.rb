class FieldingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :position, :games, :games_started, :inning_outs, :chances, :put_outs, :assists, :errors_made, :double_plays, :triple_plays, :passed_balls, :stolen_bases, :caught_stealing
	
	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		FieldingPostStat.find(:all, :select => [:player_id, :team_id, stat.to_sym, :position], :order => stat + " DESC", :limit => 50)
	end
	
	def self.career_sort(stat)
		stats = FieldingPostStat.find(:all, :select => [:player_id, stat.to_sym, :position], :joins => [:player])
		comb = {}
		stats.each { |s| 
			if comb.has_key?(s.player_id)
					comb[s.player_id] += s.send(stat).to_i
			else
				if (s.send(stat) == 0 || s.send(stat).nil?)
					comb.store(s.player_id, 0)
				else
					comb.store(s.player_id, s.send(stat))
				end
			end
		} 
		sorted = comb.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
		a[0] = Player.find(a[0])
		}
		return sorted.take(50)
	end
	
	def self.active_sort(stat)
		stats = FieldingPostStat.find(:all, :select => [:player_id, stat.to_sym, :position], :conditions => ["final_game is NULL"], :joins => [:player])
		comb = {}
		stats.each { |s| 
			if comb.has_key?(s.player_id)
					comb[s.player_id] += s.send(stat).to_i
			else
				if (s.send(stat) == 0 || s.send(stat).nil?)
					comb.store(s.player_id, 0)
				else
					comb.store(s.player_id, s.send(stat))
				end
			end
		} 
		sorted = comb.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
		a[0] = Player.find(a[0])
		}
		return sorted.take(50)
	end
	
end
