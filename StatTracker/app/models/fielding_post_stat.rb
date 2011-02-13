class FieldingPostStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :round, :position, :games, :games_started, :inning_outs, :chances, :put_outs, :assists, :errors_made, :double_plays, :triple_plays, :passed_balls, :stolen_bases, :caught_stealing
	
	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		sorted = FieldingPostStat.all.sort{|a,b| b.send(stat) <=> a.send(stat)}
		return sorted.take(50)
	end
	
end
