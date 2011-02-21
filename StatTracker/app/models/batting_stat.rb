class BattingStat < ActiveRecord::Base
  attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		batter_ids = BattingStat.find(:all, :select => :id, :order => stat + " DESC", :limit => 50)
		leaders = []
		batter_ids.each { |b|
			leaders.push(BattingStat.find(b.id))
		}
		leaders
		# sorted = BattingStat.all.sort{|a,b| b.send(stat) <=> a.send(stat)}
		# return sorted.take(50)
	end

	def self.career_sort(stat)
		stats = {}
		new = BattingStat.find(:all, :select => stat, :order => stat)
		return new.take(50)
		# BattingStat.find(:all, :select => player_id, stat) { |s|
			# if stats.has_key?(s.player_id)
				# stats[s.player_id] += s.send(stat)
			# else 
			# stats.store(s.player_id, s.send(stat))
			# end
		# }
		# sorted = stats.sort{|a,b| b[1] <=> a[1]}
		# sorted.take(50).each { |a| 
		# a[0] = Player.find(a[0])
		# }
		# return sorted.take(50)
	end
	
	def self.active_sort(stat)
		stats = {}
		BattingStat.all.each { |s|
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

  def year
    team.year
  end
	
	def batting_average
    sprintf("%.3f", avg)
	end
	
	def on_base_percentage
    sprintf("%.3f", obp)
	end

  def total_bases
    hits + doubles + (2 * triples) + (3 * home_runs)
  end

  def slugging_percentage
    sprintf("%.3f", slg)
  end

  def on_base_plus_slugging
    sprintf("%.3f", ops)
  end

  def stolen_base_percentage
    sprintf("%.3f", sbp)
  end

  def at_bats_per_strikeout
    sprintf("%.3f", ab_per_k)
  end

  def at_bats_per_home_run
    sprintf("%.3f", ab_per_hr)
  end

  def adjusted_ops
    league_obp = BattingStat.where(year => self.year).average(on_base_percentage)
    league_slg = BattingStat.where(year => self.year).average(slugging_percentage)
    100 * ((obp / league_obp) + (slg / league_slg) - 1)
  end

  def isolated_power
    sprintf("%.3f", slg - avg)
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
    sprintf("%.3f", sec_avg)
  end

  def base_runs
    #code goes here
  end

  private

  def avg
    hits / at_bats.to_f
  end

  def obp
    (hits + walks + hit_by_pitch) / (at_bats + walks + hit_by_pitch + sacrifice_hits + sacrifice_flies).to_f
  end

  def slg
    total_bases / at_bats.to_f
  end

  def ops
    obp + slg
  end

  def sbp
    stolen_bases / (stolen_bases + caught_stealing).to_f
  end

  def ab_per_k
    at_bats / strikeouts.to_f
  end

  def ab_per_hr
    at_bats / home_runs.to_f
  end

  def sec_avg
    (total_bases - hits + walks + stolen_bases - caught_stealing) / at_bats.to_f
  end
end
