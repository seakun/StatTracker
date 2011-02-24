class PitchingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :wins, :losses, :games, :games_started, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits, :earned_runs, :home_runs, :walks, :strikeouts, :intentional_walks, :wild_pitches, :hit_by_pitch, :balks, :batters_faced, :games_finished, :runs, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
    s = accessible_attributes.include?(stat)? stat.to_s : send("str_" + stat)
    min_ip = accessible_attributes.include?(stat)? 0 : 300
		PitchingStat.find(:all, :conditions => ["innings_pitched_outs > ?", min_ip], :order => s + " DESC", :limit => 50)
	end

	def self.career_sort(stat)
		stats = PitchingStat.find(:all, :select => [:player_id, stat.to_sym], :joins => [:player])
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
		stats = PitchingStat.find(:all, :select => [:player_id, stat.to_sym], :conditions => ["final_game is NULL"], :joins => [:player])
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

	def win_loss_percentage()
		sprintf("%.3f", (wins / (wins + losses).to_f))
	end

	def innings_pitched
		sprintf("%.1f", innings_pitched_outs / 3.to_f)
	end

	def era
		sprintf("%.2f", (earned_runs * 9) / innings_pitched.to_f)
	end

	def opponents_batting_average
		(hits) / (batters_faced - walks - hit_by_pitch - intentional_walks).to_f
	end

	def walks_and_hits_innings_pitched
		(walks + hits) / innings_pitched.to_f
	end

	def hits_innings
		(hits * 9) / innings_pitched.to_f
	end

	def home_runs_innings
		(home_runs * 9) / innings_pitched.to_f
	end
  
	def walks_innings
		(walks * 9) / innings_pitched.to_f
	end

	def strikeouts_innings
		(strikeouts * 9) / innings_pitched.to_f
	end

	def strikeouts_walks
		(strikeouts / walks.to_f)
	end

	def adjusted_era
		league_era = PitchingStat.where(year => self.year).average(era)
		100 * (league_era / era)
	end

  private

  def self.multiplier
    10000
  end

  def self.str_win_loss_percentage()
		"((wins * #{multiplier}) / (wins + losses))"
	end

	def self.str_innings_pitched
		"innings_pitched_outs * #{multiplier} / 3"
	end

	def self.str_era
		"((earned_runs * 9) * #{multiplier}) / (innings_pitched_outs / 3)"
	end

	def self.str_opponents_batting_average
		"(hits * #{multiplier}) / (batters_faced - walks - hit_by_pitch - intentional_walks)"
	end

	def self.str_walks_and_hits_innings_pitched
		"(walks + hits) * #{multiplier} / (innings_pitched_outs / 3)"
	end

	def self.str_hits_innings
		"(hits * 9) * #{multiplier} / (innings_pitched_outs / 3)"
	end

	def self.str_home_runs_innings
		"(home_runs * 9) * #{multiplier} / (innings_pitched_outs / 3)"
	end

	def self.str_walks_innings
		"(walks * 9) * #{multiplier} / (innings_pitched_outs / 3)"
	end

	def self.str_strikeouts_innings
		"(strikeouts * 9) * #{multiplier} / (innings_pitched_outs / 3)"
	end

	def self.str_strikeouts_walks
		"(strikeouts * #{multiplier} / walks)"
	end

	def self.str_adjusted_era
		league_era = PitchingStat.where(year => self.year).average(era)
		"100 * #{multiplier} * (#{league_era} / era)"
	end
end
