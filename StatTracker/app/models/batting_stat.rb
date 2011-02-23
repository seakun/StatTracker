class BattingStat < ActiveRecord::Base
	attr_accessible :player_id, :team_id, :stint, :games, :games_batting, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
    self.class
    s = accessible_attributes.include?(stat)? stat.to_s : send("str_" + stat)
    min_ab = accessible_attributes.include?(stat)? 0 : 400
		BattingStat.find(:all, :conditions => ["at_bats > ?", min_ab], :order => s + " DESC", :limit => 50)
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

  def home_runs_per_at_bat
    sprintf("%.3f", hr_per_ab)
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
    sprintf("%.3f", baseruns)
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
    stolen_bases / (stolen_bases + caught_stealing)
  end

  def ab_per_k
    at_bats / strikeouts.to_f
  end

  def hr_per_ab
    home_runs / at_bats.to_f
  end

  def sec_avg
    (total_bases - hits + walks + stolen_bases - caught_stealing) / at_bats.to_f
  end

  def baseruns
    a = hits + walks - home_runs
    b = (1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02
    c = at_bats - hits
    d = home_runs
    (a * b)/(b + c) + d
  end

  def self.multiplier
    10000
  end
  def self.str_batting_average
    "hits * #{multiplier} / at_bats"
	end

	def self.str_on_base_percentage
    "(hits + walks + hit_by_pitch) * #{multiplier} / (at_bats + walks + hit_by_pitch + sacrifice_hits + sacrifice_flies)"
	end

  def self.str_slugging_percentage
    "total_bases * #{multiplier} / at_bats"
  end

  def self.str_on_base_plus_slugging
    "((hits + walks + hit_by_pitch) * #{multiplier} / (at_bats + walks + hit_by_pitch + sacrifice_hits + sacrifice_flies)) + (total_bases * #{multiplier} / at_bats)"
  end

  def self.str_stolen_base_percentage
    "stolen_bases * #{multiplier} / (stolen_bases + caught_stealing)"
  end

  def self.str_at_bats_per_strikeout
    "at_bats * #{multiplier} / strikeouts"
  end

  def self.str_home_runs_per_at_bat
    "home_runs * #{multiplier} / at_bats"
  end

  def self.str_adjusted_ops
    league_obp = BattingStat.where(year => self.year).average(on_base_percentage)
    league_slg = BattingStat.where(year => self.year).average(slugging_percentage)
    100 * ((obp / league_obp) + (slg / league_slg) - 1)
  end

  def self.str_isolated_power
    "#{str_slugging_percentage} - #{str_batting_average}"
  end

  def self.str_runs_created
    "(hits + walks) * total_bases) * #{multiplier} / (at_bats + walks"
  end

  def self.str_weighted_on_base_average
    #can't figure out formula
  end

  def self.str_extrapolated_runs
    "(0.50 * (hits - doubles - triples - home_runs)) + (0.72 * doubles) + (1.04 * triples) + (1.44 * home_runs) + (0.34 * (walks)) + (0.18 * stolen_bases) + (-0.32 * caught_stealing) + (-0.096 * (at_bats - hits))"
  end

  def self.str_secondary_average
    "(total_bases - hits + walks + stolen_bases - caught_stealing) * #{multiplier} / at_bats"
  end

  def self.str_base_runs
    "((hits + walks - home_runs) * ((1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02)) * 10000/(((1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02) + (at_bats - hits)) + home_runs * 10000"
  end
end
