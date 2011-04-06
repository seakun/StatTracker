class PitchingStat < ActiveRecord::Base
    attr_accessible :player_id, :team_id, :stint, :wins, :losses, :games, :games_started, :complete_games, :shutouts, :saves, :innings_pitched_outs, :hits, :earned_runs, :home_runs, :walks, :strikeouts, :intentional_walks, :wild_pitches, :hit_by_pitch, :balks, :batters_faced, :games_finished, :runs, :sacrifice_hits, :sacrifice_flies, :grounded_into_double_plays

	belongs_to :player
	belongs_to :team
	
	def self.single_season_sort(stat)
		s = accessible_attributes.include?(stat)? stat.to_s + " DESC" : send("str_" + stat)
		min_ip = accessible_attributes.include?(stat)? 0 : 300
		PitchingStat.find(:all, :conditions => ["innings_pitched_outs > ?", min_ip], :order => s, :limit => 50)
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
	
	def self.season_compare(comp)
		split_strings = comp.split("/")
		players = []
		split_strings.each { |s|
			split = s.split(".")
			player = split[0]
			year = split[1]
			players.push(PitchingStat.find(:all, :conditions => ['player_id = ? AND year = ?', s.to_i, year], :joins => [:team]))
		}
		players
	end
	
	def self.career_compare(comp)
		split_strings = comp.split("/")
		players = {}
		split_strings.each { |s|
			stats = PitchingStat.find(:all, :conditions => ['player_id = ?', s.to_i])
			stats.each { |st|
				players.store(st, s.to_i)
			}
		}
		players
	end
	
	def self.multi_compare(comp)
		split_strings = comp.split("/")
		players = {}
		max = 0
		split_strings.each { |s|
			split_player = s.split(".")
			player = split_player[0]
			years = split_player[1]
			split_years = years.split(":")
			year1 = split_years[0]
			year2 = split_years[1]
			newmax = year2.to_i - year1.to_i + 1
			if newmax > max
				max = newmax
			end	
			stats = PitchingStat.find(:all, :conditions => ['player_id = ? AND year >= ? AND year <= ?', s.to_i, year1, year2], :joins => [:team])
			stats.each { |st|
				players.store(st, s.to_i)
			}
		}
		return players, max
	end
	
	def self.get_all_stats(player, stat)
		PitchingStat.find(:all, :select => [stat], :conditions => ['player_id = ?', player])
	end
 
	def self.get_multi_stat_total(player, stats, stat)
		total = 0
		stats.each_pair { |key, value|
			if value.to_i == player
				total += key.send(stat)
			end
		}
		total.to_s
	end
	
	def self.get_change_multi_stat_total(player, stats, stat)
		total = 0
		stats.each { |s|	
		b = PitchingStat.find(s)
			if b.player_id == player
				total += b.send(stat)
			end
		}
		total.to_s
	end
	
	def self.get_multi_stats(player, stats, stat)
		all_stats = []
		stats.each_pair { |key, value|
			if value == player
				all_stats.push(key.send(stat))
			end
		}
		all_stats
	end
	
	def self.get_change_multi_stats(player, stats, stat)
		all_stats = []
		stats.each { |s|
		b = PitchingStat.find(s)
			if b.player_id == player
				all_stats.push(b.send(stat))
			end
		}
		all_stats
	end
	
	def self.get_stat_total(player, stat)
		stats = PitchingStat.find(:all, :select => [stat], :conditions => ['player_id = ?', player])
		count = 0
		stats.each { |s|
		count += s.send(stat)
		}
		count.to_s
	end
	
	def year
		team.year
	end

	def win_loss_percentage()
		sprintf("%.4f", (wins / (wins + losses).to_f))
	end

	def innings_pitched
		sprintf("%.1f", innings_pitched_outs / 3.to_f)
	end

	def era
		sprintf("%.4f", (earned_runs * 9) / innings_pitched.to_f)
	end

	def opponents_batting_average
		sprintf("%.4f", ((hits) / (batters_faced - walks - hit_by_pitch).to_f))
	end

	def walks_and_hits_innings_pitched
		sprintf("%.4f", ((walks + hits) / innings_pitched.to_f))
	end

	def hits_per_9_innings
		sprintf("%.4f", ((hits * 9) / innings_pitched.to_f))
	end

	def home_runs_per_9_innings
		sprintf("%.4f", ((home_runs * 9) / innings_pitched.to_f))
	end
  
	def walks_per_9_innings
		sprintf("%.4f", ((walks * 9) / innings_pitched.to_f))
	end

	def strikeouts_per_9_innings
		sprintf("%.4f", ((strikeouts * 9) / innings_pitched.to_f))
	end

	def strikeouts_per_walk
		sprintf("%.4f", ((strikeouts / walks.to_f)))
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
		"((wins * #{multiplier}) / (wins + losses)) DESC"
	end

	def self.str_innings_pitched
		"innings_pitched_outs * #{multiplier} / 3 DESC"
	end

	def self.str_era
		"((earned_runs * 9) * #{multiplier}) / (innings_pitched_outs / 3) ASC"
	end

	def self.str_opponents_batting_average
		"((hits * #{multiplier}) / (batters_faced - walks - hit_by_pitch - intentional_walks)) ASC"
	end

	def self.str_walks_and_hits_innings_pitched
		"(walks + hits) * #{multiplier} / (innings_pitched_outs / 3) ASC"
	end

	def self.str_hits_per_9_innings
		"(hits * 9) * #{multiplier} / (innings_pitched_outs / 3) ASC"
	end

	def self.str_home_runs_per_9_innings
		"(home_runs * 9) * #{multiplier} / (innings_pitched_outs / 3) ASC"
	end

	def self.str_walks_per_9_innings
		"(walks * 9) * #{multiplier} / (innings_pitched_outs / 3) ASC"
	end

	def self.str_strikeouts_per_9_innings
		"(strikeouts * 9) * #{multiplier} / (innings_pitched_outs / 3) DESC"
	end

	def self.str_strikeouts_per_walk
		"(strikeouts * #{multiplier} / walks) DESC"
	end

	def self.str_adjusted_era
		league_era = PitchingStat.where(year => self.year).average(era)
		"100 * #{multiplier} * (#{league_era} / era) DESC"
	end
end
