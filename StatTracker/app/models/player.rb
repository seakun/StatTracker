class Player < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :name, :nickname, :birth_year, :birth_month, :birth_day, :birth_country, :birth_state, :birth_city, :death_year, :death_month, :death_day, :death_country, :death_state, :death_city, :weight, :height, :bats, :throws, :debut, :final_game, :college, :hof, :plate_appearances, :at_bats, :hits, :home_runs, :total_bases, :stolen_bases, :caught_stealing, :walks, :strikeouts, :walks, :hit_by_pitch, :sacrifice_flies, :plate_appearances_post, :at_bats_post, :hits_post, :home_runs_post, :total_bases_post, :stolen_bases_post, :caught_stealing_post, :walks_post, :strikeouts_post, :hit_by_pitch_post, :sacrifice_flies_post, :wins, :losses, :innings_pitched_outs, :earned_runs, :runs_allowed, :hits_allowed, :batters_faced, :walks_allowed, :hit_by_pitches_allowed, :home_runs_allowed, :strikeouts_allowed, :wins_post, :losses_post, :innings_pitched_outs_post, :earned_runs_post, :runs_allowed_post, :hits_allowed_post, :batters_faced_post, :walks_allowed_post, :hit_by_pitches_allowed_post, :home_runs_allowed_post, :strikeouts_allowed_post, :put_outs, :assists, :inning_outs, :games_played, :put_outs_post, :assists_post, :inning_outs_post, :games_played_post

    has_many :batting_stats
	has_many :batting_post_stats
	has_many :pitching_stats
	has_many :pitching_post_stats
	has_many :fielding_stats
	has_many :fielding_post_stats
	
	def age(year)
		birthday = DateTime.new(y=birth_year, m = birth_month, d = birth_day)
		season_start = DateTime.new(y=year, m = 7, d = 1, h=0, m=0, s=0)
		(season_start-birthday).to_i/365
	end
	
	def heightFeet
		(height/12).to_s+"\' "+(height%12).to_s+"\""
	end

	def birthPlace
	if birth_state.nil?
	return birth_city+ ", "+birth_country
	elsif birth_city.nil? && birth_state.nil?
	return birth_country
	elsif !birth_city.nil? && !birth_state.nil? && !birth_country.nil?
	return birth_city+ ", "+birth_state+ ", "+birth_country
	end
	end

  # search for all the players in the system by either first or last name
  def self.search(search)
    search_condition = "%" + search.downcase + "%"
    find(:all, :conditions => ["lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(first_name) || ' ' || lower(last_name) LIKE ?", search_condition, search_condition, search_condition])
  end
  
  def auto_search
	if !debut.nil?
		if final_game.nil?
			name + ", " + debut.year.to_s + " - "
		else 
			name + ", " + debut.year.to_s + " - " + final_game.year.to_s
		end
	end
  end

  def filter
    @players = Player.paginate :page => params[:page], :order => 'last_name',
         :conditions=>["last_name LIKE ? or last_name LIKE ? or last_name LIKE ? last_name like ?",
         'A%', 'B%', 'C%', 'D%']
  end
  
	def self.multiplier
		10000
	end
  
	def self.str_career_batting_average
		"career_hits * #{multiplier} / career_at_bats DESC"
	end
	
	def self.str_career_on_base_percentage
    "(career_hits + career_walks + career_hit_by_pitch) * #{multiplier} / (career_at_bats + career_walks + career_hit_by_pitch + career_sacrifice_flies) DESC"
	end

  def self.str_career_slugging_percentage
    "career_total_bases * #{multiplier} / career_at_bats DESC"
  end

  def self.str_career_on_base_plus_slugging
    "((career_hits + career_walks + career_hit_by_pitch) * #{multiplier} / (career_at_bats + career_walks + career_hit_by_pitch + career_sacrifice_flies)) + (career_total_bases * #{multiplier} / career_at_bats) DESC"
  end

  def self.str_career_stolen_base_percentage
    "career_stolen_bases * #{multiplier} / (career_stolen_bases + career_caught_stealing) DESC"
  end

  def self.str_career_at_bats_per_strikeout
    "career_at_bats * #{multiplier} / career_strikeouts DESC"
  end

  def self.str_career_at_bats_per_home_run
    "(career_at_bats * #{multiplier} / career_home_runs) ASC"
  end

  def self.str_career_adjusted_ops
    league_obp = BattingStat.where(year => self.year).average(on_base_percentage)
    league_slg = BattingStat.where(year => self.year).average(slugging_percentage)
    100 * ((obp / league_obp) + (slg / league_slg) - 1)
  end

  def self.str_career_isolated_power
    "#{str_career_slugging_percentage} - #{str_career_batting_average} DESC"
  end

  def self.str_career_runs_created
    "((career_hits + career_walks) * career_total_bases) * #{multiplier} / (career_at_bats + career_walks) DESC"
  end

  def self.str_career_secondary_average
    "(career_total_bases - career_hits + career_walks + career_stolen_bases - career_caught_stealing) * #{multiplier} / career_at_bats DESC"
  end

  def self.str_career_base_runs
    "((career_hits + career_walks - career_home_runs) * ((1.4 * career_total_bases - 0.6 * career_hits - 3 * career_home_runs + 0.1 * career_walks) * 1.02)) * 10000/(((1.4 * career_total_bases - 0.6 * career_hits - 3 * career_home_runs + 0.1 * career_walks) * 1.02) + (career_at_bats - career_hits)) + career_home_runs * 10000 DESC"
  end
	
	def career_batting_average
		sprintf("%.3f", avg)
	end
	
	def career_on_base_percentage
		sprintf("%.3f", obp)
	end
  
	def career_slugging_percentage
		sprintf("%.3f", slg)
	end

	def career_on_base_plus_slugging
		sprintf("%.3f", ops)
	end

	def career_at_bats_per_strikeout
		sprintf("%.2f", ab_per_k)
	end

	def career_at_bats_per_home_run
		sprintf("%.2f", ab_per_hr)
	end

	def career_adjusted_ops
		league_obp = BattingStat.where(year => self.year).average(on_base_percentage)
		league_slg = BattingStat.where(year => self.year).average(slugging_percentage)
		100 * ((obp / league_obp) + (slg / league_slg) - 1)
	end

	def career_isolated_power
		sprintf("%.3f", slg - avg)
	end

	def career_runs_created
		((career_hits + career_walks) * career_total_bases) / (career_at_bats + career_walks)
	end

	def career_secondary_average
		sprintf("%.3f", sec_avg)
	end

	def career_base_runs
		sprintf("%.3f", baseruns)
	end
  
	private

	def avg
		career_hits / career_at_bats.to_f
	end

	def obp
		(career_hits + career_walks + career_hit_by_pitch) / (career_at_bats + career_walks + career_hit_by_pitch + career_sacrifice_flies).to_f
	end

	def slg
		career_total_bases / career_at_bats.to_f
	end

	def ops
		obp + slg
	end

	def ab_per_k
		career_at_bats / career_strikeouts.to_f
	end

	def ab_per_hr
		career_at_bats / career_home_runs.to_f
	end

	def sec_avg
		(career_total_bases - career_hits + career_walks + career_stolen_bases - career_caught_stealing) / career_at_bats.to_f
	end

	def baseruns
		a = career_hits + career_walks - career_home_runs
		b = (1.4 * career_total_bases - 0.6 * career_hits - 3 * career_home_runs + 0.1 * career_walks) * 1.02
		c = career_at_bats - career_hits
		d = career_home_runs
		(a * b)/(b + c) + d
	end
end
