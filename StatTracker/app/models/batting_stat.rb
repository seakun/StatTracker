class BattingStat < ActiveRecord::Base
	attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		BattingStat.find(:all, :select => [:player_id, :team_id, stat.to_sym], :order => stat + " DESC", :limit => 50)
	end

	def self.career_sort(stat)
		stats = BattingStat.find(:all, :select => [:player_id, stat.to_sym], :joins => [:player])
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
		stats = BattingStat.find(:all, :select => [:player_id, stat.to_sym], :conditions => ["final_game is NULL"], :joins => [:player])
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
    ((hits + walks) * total_bases) / (at_bats + walks)
  end

  def weighted_on_base_average
    #can't figure out formula
  end

  def extrapolated_runs
    (0.50 * (hits - doubles - triples - home_runs)) + (0.72 * doubles) + (1.04 * triples) + (1.44 * home_runs) + (0.34 * (walks)) + (0.18 * stolen_bases) + (-0.32 * caught_stealing) + (-0.096 * (at_bats - hits))
  end

  def secondary_average
    sprintf("%.3f", sec_avg)
  end

  def base_runs
    a = hits + walks - home_runs
    b = (1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02
    c = at_bats - hits
    d = home_runs
    (a * b)/(b + c) + d
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
