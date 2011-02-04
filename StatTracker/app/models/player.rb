class Player < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :nickname, :birth_year, :birth_month, :birth_day, :birth_country, :birth_state, :birth_city, :death_year, :death_month, :death_day, :death_country, :death_state, :death_city, :weight, :height, :bats, :throws, :debut, :final_game, :college, :hof

	has_many :batting_post_stats
	has_many :pitching_post_stats
	has_many :fielding_post_stats
	has_many :batting_stats
	has_many :pitching_stats
	has_many :fielding_stats
	has_many :teams, :through => :batting_stats
	has_many :teams, :through => :pitching_stats
	has_many :teams, :through => :fielding_stats
	has_many :teams, :through => :batting_post_stats
	has_many :teams, :through => :pitching_post_stats
	has_many :teams, :through => :fielding_post_stats
	
end
