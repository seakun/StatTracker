class Player < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :name, :nickname, :birth_year, :birth_month, :birth_day, :birth_country, :birth_state, :birth_city, :death_year, :death_month, :death_day, :death_country, :death_state, :death_city, :weight, :height, :bats, :throws, :debut, :final_game, :college, :hof

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
		"hits * #{multiplier} / at_bats DESC"
	end
	
	def self.str_career_on_base_percentage
    "(hits + walks + hit_by_pitch) * #{multiplier} / (at_bats + walks + hit_by_pitch + sacrifice_flies) DESC"
	end

  def self.str_career_slugging_percentage
    "total_bases * #{multiplier} / at_bats DESC"
  end

  def self.str_career_on_base_plus_slugging
    "((hits + walks + hit_by_pitch) * #{multiplier} / (at_bats + walks + hit_by_pitch + sacrifice_flies)) + (total_bases * #{multiplier} / at_bats) DESC"
  end

  def self.str_career_stolen_base_percentage
    "stolen_bases * #{multiplier} / (stolen_bases + caught_stealing) DESC"
  end

  def self.str_career_at_bats_per_strikeout
    "at_bats * #{multiplier} / strikeouts DESC"
  end

  def self.str_career_at_bats_per_home_run
    "(at_bats * #{multiplier} / home_runs) ASC"
  end

  def self.str_career_adjusted_ops
    league_obp = BattingStat.where(year => self.year).average(on_base_percentage)
    league_slg = BattingStat.where(year => self.year).average(slugging_percentage)
    100 * ((obp / league_obp) + (slg / league_slg) - 1)
  end

  def self.str_career_isolated_power
    "#{str_slugging_percentage} - #{str_batting_average} DESC"
  end

  def self.str_career_runs_created
    "((hits + walks) * total_bases) * #{multiplier} / (at_bats + walks) DESC"
  end

  def self.str_career_extrapolated_runs
    "(0.50 * (hits - doubles - triples - home_runs)) + (0.72 * doubles) + (1.04 * triples) + (1.44 * home_runs) + (0.34 * (walks)) + (0.18 * stolen_bases) + (-0.32 * caught_stealing) + (-0.096 * (at_bats - hits)) DESC"
  end

  def self.str_career_secondary_average
    "(total_bases - hits + walks + stolen_bases - caught_stealing) * #{multiplier} / at_bats DESC"
  end

  def self.str_career_base_runs
    "((hits + walks - home_runs) * ((1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02)) * 10000/(((1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02) + (at_bats - hits)) + home_runs * 10000 DESC"
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
		((hits + walks) * total_bases) / (at_bats + walks)
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
		(hits + walks + hit_by_pitch) / (at_bats + walks + hit_by_pitch + sacrifice_flies).to_f
	end

	def slg
		total_bases / at_bats.to_f
	end

	def ops
		obp + slg
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

	def baseruns
		a = hits + walks - home_runs
		b = (1.4 * total_bases - 0.6 * hits - 3 * home_runs + 0.1 * walks) * 1.02
		c = at_bats - hits
		d = home_runs
		(a * b)/(b + c) + d
	end
end
