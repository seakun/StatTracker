class Player < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :nickname, :birth_year, :birth_month, :birth_day, :birth_country, :birth_state, :birth_city, :death_year, :death_month, :death_day, :death_country, :death_state, :death_city, :weight, :height, :bats, :throws, :debut, :final_game, :college, :hof
	
	has_many :batting_stats
	has_many :batting_post_stats
	has_many :pitching_stats
	has_many :pitching_post_stats
	has_many :fielding_stats
	has_many :fielding_post_stats
	
	def self.get_career_total(stat)
		Player.all.each {|p|	
		}
	end
	
	def name
		first_name + " " + last_name
	end
	
end
