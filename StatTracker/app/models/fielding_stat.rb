class FieldingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :position, :games, :games_started, :inning_outs, :chances, :put_outs, :assists, :errors_made, :double_plays, :passed_balls, :wild_pitches, :stolen_bases, :caught_stealing, :zone_rating
	
	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort()
		sorted = FieldingStat.all.sort{|a,b| b.errors_made <=> a.errors_made}
		return sorted.take(50)
	end
	
end
