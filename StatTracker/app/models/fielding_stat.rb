class FieldingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :position, :games, :games_started, :inning_outs, :chances, :put_outs, :assists, :errors_made, :double_plays, :passed_balls, :wild_pitches, :stolen_bases, :caught_stealing, :zone_rating
	
	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		sorted = FieldingStat.all.sort{|a,b| b.send(stat) <=> a.send(stat)}
		return sorted.take(50)
	end
	
	def self.career_sort(stat)
		stats = {}
		FieldingStat.all.each { |s|
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
		FieldingStat.all.each { |s|
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

	def chances
		put_outs + assists + errors_made
	end

  def innings
    innings_outs / 3
  end

  def fielding_percentage
    sprintf("%.3f", ((put_outs + assists) / chances) )
  end

  def range_factor_innings
    9 * (put_outs + assists) / innings
  end

  def range_factor__game
    (put_outs + assists) / games
  end
  
#  League Fielding Percentage (lgfLD%)
#League Range Factor/9 Innings (lgRF9)
#League Range Factor/ Game (lgRFG)


end
