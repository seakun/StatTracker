class BattingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
    sorted = BattingStat.all.sort{|a,b| b.send(stat) <=> a.send(stat)}
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
		return sorted.take(50)
	end
	
	def self.active_sort()
		stats = {}
		BattingStat.all.each { |s|
			player = Player.find(s.player_id)
			if player.final_game.equal?(nil)
				if stats.has_key?(player)
					stats[player] += s.home_runs
				else stats.store(player, s.home_runs)
				end
			end
		}
		sorted = stats.sort{|a,b| b[1] <=> a[1]}
		sorted.take(50).each { |a| 
			a[0] = Player.find(a[0])
		}
		return sorted.take(50)
	end

  def year
    team.year
  end
	
	def batting_average
		value = hits / at_bats
    sprintf(".3f", value)
	end
	
	def on_base_percentage
		value = (hits + walks + hit_by_pitch) / (at_bats + walks + hit_by_pitch + sacrifice_hits + sacrifice_flies)
    sprintf(".3f", value)
	end

  def total_bases
    hits + doubles + (2 * triples) + (3 * home_runs)
  end

  def slugging_percentage
    total_bases / at_bats
  end

  def ops
    on_base_percentage + slugging_percentage
  end

  def stolen_base_percentage
    stolen_bases / (stolen_bases + caught_stealing)
  end

  def at_bats_per_strikeout
    at_bats / strikeouts
  end

  def at_bats_per_home_run
    at_bats / home_runs
  end

  def adjusted_ops
    league_obp = BattingStat.where(year => self.year).average(on_base_percentage)
    league_slg = BattingStat.where(year => self.year).average(slugging_percentage)
    100 * ((on_base_percentage / league_obp) + (slugging_percentage / league_slg) - 1)
  end

  def isolated_power
    slugging_percentage - batting_average
  end

  def runs_created
    #code goes here
  end

  def weighted_on_base_average
    #code goes here
  end

  def extrapolated_runs
    #code goes here
  end

  def secondary_average
    (total_bases - hits + walks + stolen_bases - caught_stealing) / at_bats
  end

  def base_runs
    #code goes here
  end
end
