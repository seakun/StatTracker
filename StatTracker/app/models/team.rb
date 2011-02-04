class Team < ActiveRecord::Base
    attr_accessible :franchise_id, :division_id, :year, :baseball_era, :name, :park, :attendance, :rank, :games, :home_games, :wins, :losses, :div_win, :wc_win, :lg_win, :ws_win, :runs, :at_bats, :hits, :doubles, :triples, :home_runs, :walks, :strikeouts, :stolen_bases, :caught_stealing, :hit_by_pitch, :sacrifice_flies, :runs_allowed, :earned_run, :earned_run_average, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits_allowed, :home_runs_allowed, :walks_allowed, :strikeouts_allowed, :errors_made, :double_plays, :fielding_percentage, :batters_park_factor, :pitchers_park_factor

	has_many :batting_post_stats
	has_many :pitching_post_stats
	has_many :fielding_post_stats
	has_many :batting_stats
	has_many :pitching_stats
	has_many :fielding_stats
	belongs_to :division
	belongs_to :franchise
	has_many :players, :through => :batting_stats
	has_many :players, :through => :pitching_stats
	has_many :players, :through => :fielding_stats
	has_many :players, :through => :batting_post_stats
	has_many :players, :through => :pitching_post_stats
	has_many :players, :through => :fielding_post_stats
	
end
