class BattingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :games, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, :total_bases, :extra_base_hits, :rbi, :stolen_bases, :caught_stealing, :walks, :strikeouts, :intentional_walks, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort()
		sorted = BattingPostStat.all.sort{|a,b| b.doubles <=> a.doubles}
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
